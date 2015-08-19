#!/bin/bash
# PulseAudio [up|down|mute] controls for default sink
# Updates: http://github.com/lidel/dotfiles/

DEFAULT_SINK=`pacmd dump | grep set-default-sink | cut -d " " -f 2`

case $1 in
    up)
        exec pactl set-sink-volume $DEFAULT_SINK -- +1%
        ;;
    down)
        exec pactl set-sink-volume $DEFAULT_SINK -- -1%
        ;;
    mute)
        exec pactl set-sink-mute   $DEFAULT_SINK -- toggle
        ;;
    *)
        echo "Usage: `basename $0` [up|down|mute]"
        exit 1;;
esac
