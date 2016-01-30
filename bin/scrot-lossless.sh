#!/bin/sh
# simple scrot wrapper that runs lossless optimization
# via optipng (http://optipng.sourceforge.net/)
# (put here since dmenu does not know about .zshrc aliases)
exec /usr/bin/scrot -e 'mkdir -p ~/tmp/screnshots && mv $f ~/tmp/screnshots && \
    nice optipng -o7 -i0 ~/tmp/screnshots/$f' \
    $*
