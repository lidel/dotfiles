#!/bin/bash
# Sony Vaio VGN-FW21E backlight control utility
# by Marcin Rataj (http://lidel.org)
# Updates: http://github.com/lidel/dotfiles/
# License: public domain
#
# Use with xf86-video-ati (formerly radeonhd)

max=$(cat /sys/class/backlight/acpi_video0/max_brightness)

function set_backlight() {
    # value range check
    if $(test $1 -ge 0 && test $1 -le $max); then
        echo -n $1 > /sys/class/backlight/acpi_video0/brightness
    fi
}

# if $1 is a number, try to set backlight to its value
if $(test "$1" -ge 0 -o "$1" -lt 0 2>&-); then
    set_backlight $1 && exit 0
fi

current=$(cat /sys/class/backlight/acpi_video0/brightness)

case $1 in
    up)     new=$(($current+1)) ;;
    down)   new=$(($current-1)) ;;
    *)      echo "Usage: $(basename $0) [up|down|0-$max]"; exit 1;;
esac

set_backlight $new && exit 0

