#!/bin/bash
# PulseAudio volume control script
# by Marcin Rataj (http://lidel.org)
# Updates: http://github.com/lidel/dotfiles/
# License: public domain

# Features:
#   - [up|down|mute] controls
#   - digital amplification
#   - default sink detection

FULL=$((0x10000)) # 100%
STEP=$((0x0028F)) #  ~1%

DUMP=`pacmd dump`
DEFAULT_SINK=`echo "$DUMP" | grep set-default-sink | cut -d " " -f 2`
OLD_VOL=`echo "$DUMP" | grep "set-sink-volume $DEFAULT_SINK" | cut -d " " -f 3`

case $1 in
    up)
        NEW_VOL=$((OLD_VOL + STEP))
        # no roof limit (digital amplification feature)
        ;;
    down)
        NEW_VOL=$((OLD_VOL - STEP))
        # respect floor limit
        if [ $NEW_VOL -lt $((0x00000)) ]
        then
            NEW_VOL=$((0x00000))
        fi
        ;;
    mute)
        MUTE=`echo "$DUMP" | grep "set-sink-mute $DEFAULT_SINK" | cut -d " " -f 3`
        if [ $MUTE == "no" ]
        then
            pactl set-sink-mute $DEFAULT_SINK yes
        else
            pactl set-sink-mute $DEFAULT_SINK no
        fi
        exit $?;;
    *)
        echo "Usage: `basename $0` [up|down]"
        exit 1;;
esac

pactl set-sink-volume $DEFAULT_SINK `printf "0x%X" $NEW_VOL`

