# JOURNAL

## Progress Journal

* basic functionality has been achieved
* all of the behavior refactored into methods
* some of the values need to be parameterized in order to support other projects
* at the moment the script works for the OSI project
* the port mapping is still hard-coded
* updating of the hosts files is also missing. Needs more investigation, maybe not so required
* random port mappings have been added

## Findings

The magento side of the project seems unimportant. This could technically be done with any project. Also, there is no need
to polute the current script with any project or framework specific requirements.

Yq tool turned out to be great. Very simple to use and very useful.

## Next steps
* <b>high</b> parameterize the script
~~* <b>mid</b> improve the current implementation: possibility to put volumes and ports into arrays for mapping~~
* <b>low</b> hosts file needs to be updated
* <b>high</b> adding support for branches
* <b>low</b> use a designated folder to house the clones, low priority for now
~~* <b>high</b> update env.php~~
* <b>use a subdomain based on the branch name for the base URL</b>
* <b>move the cloned projects to a specific directory</b>

## Feature

### Support for branches

This would give the possibility to have more than one cloned project. The naming would be based of of the branch.

## Problem

### URL issue

env.php needs to be updated inside the container, otherwise, the url update doesn't work.

<i>This might also be updated in env.php directly</i>

**Resolved** by modifying env.php

