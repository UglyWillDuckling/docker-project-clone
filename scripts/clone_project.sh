#!/bin/bash

set -eu

start_dir=~/dev/web/projects/clone

# TODO make all of this variable
project_name="osi"
git_repo="git@code.monsoonconsulting.com:magento2/osi.git"
branch="clone_project"

clone_the_repo() {
  git clone $git_repo .
  git checkout $branch
}

clone_dir="$project_name"_clone

volume_names=("sql" "www")
clone_volumes() {
  for vol in "${volume_names[@]}"
  do
    original_volume="$project_name"_"$vol"
    clone_volume_name="$clone_dir"_"$vol"
    bin/volume_clone $original_volume $clone_volume_name >/dev/null
  done
}

create_clone_directory() {
  if [[ -d "$clone_dir" ]] 
  then
    rm -rf $clone_dir
  fi;

  mkdir $clone_dir
  cd "$clone_dir"
}

bin_dir="$HOME/dev/web/projects/osi/osi-shop/bin"
copy_bin() {
  cp -r $bin_dir .
}

generate_random_port() {
  shuf -i 2000-65000 -n 1
}

nginx_port=$(generate_random_port)
db_port=$(generate_random_port)

update_ports_config() {
    nginx_port_mapping=$nginx_port:443
    db_port_mapping=$db_port:3306
    echo Updating the docker compose config file...
    yq 'del(.services | .[] | .ports)' .docker/docker-compose.yml | sponge .docker/docker-compose.yml # remove all port mappings
    yq ".services.nginx.ports=[\"$nginx_port_mapping\"] | .services.database.ports=[\"$db_port_mapping\"]" .docker/docker-compose.yml | sponge .docker/docker-compose.yml
}

update_env_config() {
  echo Updating the .env file...
  (echo "COMPOSE_PROJECT_NAME=$clone_dir" > .docker/.env)
}

update_docker_config() {
  update_env_config
  update_ports_config
}

docker_start() {
  (cd .docker && docker-compose up -d)
}

clone_url=https://dev-"$project_name":$nginx_port/
update_url() {
  # Updating the URL in the database, watch it here, this can be overriden in env.php
  echo Updating the projects main URL

  local container_name="$clone_dir"_php_1
  local tmp_file_name="tmp_env.php"

  docker cp osi_clone_php_1:/var/www/html/app/etc/env.php $tmp_file_name
  echo "<?php return " $(php -r "\$config = require_once '$tmp_file_name'; unset(\$config['system']); var_export(\$config);") ";" > $tmp_file_name
  docker cp ./$tmp_file_name $container_name:/var/www/html/app/etc/env.php

  bin/mysql -e "update core_config_data set value='$clone_url' where path like '%base_url'"
}

echo Cloning the project; echo

# we will need to update this in the future
cd "$start_dir"

echo Cloning the volumes
clone_volumes

echo Creating the directory structure...
create_clone_directory

# clone the git repo here
echo Cloning the repo...
clone_the_repo

echo Copying the bin directory
copy_bin

echo Updating docker config
update_docker_config

echo; echo Lift Off!!!
docker_start

echo; echo Updating the URL
update_url

echo
echo Finished cloning the project
echo The project is located here $clone_dir
echo the projects URL is $clone_url
echo Enjoy!

# echo; echo !Sorry, but we are still missing the update of the hosts files

