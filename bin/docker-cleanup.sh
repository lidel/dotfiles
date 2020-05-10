#!/bin/env bash

set -e

# run with low priority
ionice -c 3 -p $$
renice +12  -p $$
chrt -v -i -p 0 $$

# containers that exited 5+ weeks ago
docker ps -a -f status=exited | grep -E 'Exited \([0-9]+\) [5-9] weeks ago' | awk '{print $1}' | xargs -r docker rm

# created and abandoned
docker ps -a -f status=created | grep -E '[5-9] weeks ago' | awk '{print $1}' | xargs -r docker rm

# dangling images
docker images --no-trunc -q -f dangling=true | xargs -r docker rmi

