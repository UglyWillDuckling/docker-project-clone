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

- [ ] improve the current implementation: possibility to put volumes and ports into arrays for mapping
- [ ] hosts file needs to be updated
- [ ] use a subdomain based on the branch name for the base URL
- [x] update env.php
- [x] move the cloned projects to a specific directory
- [x] parameterize the script

## Features

### Support for branches

This would give the possibility to have more than one cloned project. The naming would be based of of the branch.

**Implemented**

### Volumes and ports mapping

it would be possible to provide an additional list of port mappings and volume mappings.

The port mappings would include service names and host/container port mapping.
The volume list would only require the original volume name.

## Problems

### URL issue

env.php needs to be updated inside the container, otherwise, the url update doesn't work.

<i>This might also be updated in env.php directly</i>

**Resolved** by modifying env.php

