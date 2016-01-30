#!/bin/sh
# Improved version of the original script from
# http://psi-im.org/wiki/Publish_Tune
# that takes advantage of MPD idle architecture

while [ 1 ] ; do
    mpc current --format "%title%
%artist%
%album%
%track%
%time%" > ~/.psi/tune
    mpc idle > /dev/null
done

