#!/bin/sh
# Make sure that all urxvtc instances
# are handled by urxvtd daemon

cd ~
[[ -n `pidof urxvtd` ]] && exec urxvtc "$@"
if [[ -z `pidof urxvtd` ]]; then
    urxvtd -q -o -f
    exec urxvtc "$@"
fi

