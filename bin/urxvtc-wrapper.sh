#!/bin/sh
# This wrapper makes sure that all urxvtc instances
# are handled by a single, lazy-loaded urxvtd daemon
cd $HOME
[[ -n `pidof urxvtd` ]] && exec urxvtc "$@"
if [[ -z `pidof urxvtd` ]]; then
    urxvtd -q -o -f
    exec urxvtc "$@"
fi
