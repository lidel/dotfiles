#!/bin/sh
# (Simplified) PulseAudio Volume Control Script
#   2010-07-05 - Marcin Rataj (http://github.com/lidel/dotfiles)
#                * removed unused functions and added .vol pipe
#   2010-05-20 - Gary Hetzel  (http://gzn.pastebin.com/F1tM6R2J)

SINK=0
STEP=5
MAXVOL=65537 # let's just assume this is the same all over
#MAXVOL=`pacmd list-sinks | grep "volume steps" | cut -d: -f2 | tr -d "[:space:]"`

VOLPERC=`pacmd list-sinks | grep "volume" | head -n1 | cut -d: -f3 | cut -d% -f1 | tr -d "[:space:]"`

# alternative implementation
# pacmd set-sink-volume 0 $(printf '0x%x' $(( $(pacmd dump|grep set-sink-volume|cut -f3 -d' '|head -1) + 0xf00)) )"

case $1 in
    up)
        VOLSTEP="$(( $VOLPERC+$STEP ))";;
    down)
        VOLSTEP="$(( $VOLPERC-$STEP ))";;
    *)
        echo "Usage: `basename $0` [up|down]"
        exit 1;;
esac

VOLUME="$(( ($MAXVOL/100) * $VOLSTEP ))"
pacmd set-sink-volume $SINK $VOLUME > /dev/null

# pipe used by xmobar's PipeReader widget
echo $VOLSTEP > ~/.vol

