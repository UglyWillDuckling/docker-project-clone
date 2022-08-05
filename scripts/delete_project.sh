#!/bin/bash

set -eu

project_name=${1:-""}
branch=${2:-""}

usage() {
    echo "usage: `basename $0` project-name git-repo [branch]"
}

if [ -z "$project_name" ] || [ -z "$branch" ]; then
  echo "missing required arguments"
  usage
  exit 1
fi

clone_project_name="$project_name"_clone_"$branch"
clone_dir="projects/$clone_project_name"

remove_volumes() {
  local volume_names=("www" "sql")

  for vol in "${volume_names[@]}"
  do
    clone_volume_name="$clone_project_name"_"$vol"
    docker volume rm $clone_volume_name || true
  done
}

remove_containers() {
   local containers=("database" "php" "elasticsearch" "redis" "nginx" "mailcatcher" "rabbitmq" "integrationdb" "mutagen")

   for container in "${containers[@]}"
   do
       local container_name="$clone_project_name"-"$container"-1
       docker stop $container_name || true
       docker rm $container_name || true
   done
}

remove_project_dir() {
    rm -rf "$clone_dir"
}

echo removing containers
remove_containers
echo removing volumes
remove_volumes
echo removing directory "$clone_dir"
remove_project_dir

