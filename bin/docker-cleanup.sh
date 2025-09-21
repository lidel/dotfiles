#!/bin/env bash

set -e

# run with low priority
ionice -c 3 -p $$
renice +12  -p $$
chrt -v -i -p 0 $$

# containers that exited 5+ weeks ago
docker ps -a -f status=exited | grep -E 'Exited \([0-9]+\) ([5-9] weeks|.+ months|.+ years) ago' | awk '{print $1}' | xargs -r docker rm

# created and abandoned
docker ps -a -f status=created | grep -E '[5-9] weeks ago|months ago|years ago' | awk '{print $1}' | xargs -r docker rm

# system-wide cleanup: stopped containers, unused networks, images, build cache
# using 840h (5 weeks) filter to match the policy above
docker system prune -a -f --filter "until=840h"

# cleanup unused volumes separately (doesn't support until filter)
docker volume prune -f

# additional build cache cleanup (remove all unused cache)
# using --all because Docker updates access times when checking cache
docker builder prune -a -f --all

# show disk usage after cleanup
docker system df
