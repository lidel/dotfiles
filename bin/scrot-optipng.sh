#!/bin/sh
# simple scrot wrapper that runs
# optipng (http://optipng.sourceforge.net/) on shots
# (put here since dmenu does not know about .zshrc aliases)
exec /usr/bin/scrot -e 'mkdir -p ~/TODO/screnshots && mv $f ~/TODO/screnshots && nice optipng -o7 -i0 ~/TODO/screnshots/$f' $*
