#!/bin/sh
# Sony Vaio VGN-FW21E backlight control utility
# by Marcin Rataj (http://lidel.org)
# Updates: http://github.com/lidel/dotfiles/
# License: public domain
#
# Wrapper over low-level tool (vaio-backlight-raw.sh) taken
# from https://bugzilla.kernel.org/show_bug.cgi?id=11682#c32

rhddump="sudo `which rhd_dump`"

#pcitag=`lspci | grep VGA | cut -d ' ' -f 1`
pcitag="01:00.0"

current=`$rhddump -r 7F94,7F94: $pcitag | tail -1 | cut -d: -f2 | tr -d '[:space:]'`

case $current in
    "0x00FF3701") val=1;;
    "0x00FF4001") val=2;;
    "0x00FF4F01") val=3;;
    "0x00FF5E01") val=4;;
    "0x00FF6F01") val=5;;
    "0x00FF8601") val=6;;
    "0x00FFA001") val=7;;
    "0x00FFC301") val=8;;
    "0x00FFC300") val=9;;
    *)            echo "Check vaio-backlight-raw.sh configuration"; exit 1;;
esac

case $1 in
    up)     new=$(($val+1)) ;;
    down)   new=$(($val-1)) ;;
    *)      echo "Usage: `basename $0` [up|down]"; exit 1;;
esac

if $(test $new -ge 1 && test $new -le 9 ); then
    vaio-backlight-raw.sh $new
fi

