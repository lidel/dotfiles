#!/bin/sh
# simple scrot wrapper that runs lossy optimizations
# optipng (http://optipng.sourceforge.net/)
# pngquant (32-bit paletter to 8-bit -- acceptable for screenshots)
# (put here since dmenu does not know about .zshrc aliases)
exec /usr/bin/scrot -e 'mkdir -p ~/tmp/screnshots && mv $f ~/tmp/screnshots && \
    nice pngquant --verbose --quality 1 --skip-if-larger -fo ~/tmp/screnshots/$f ~/tmp/screnshots/$f && \
    nice optipng -o7 -i0 ~/tmp/screnshots/$f' \
    $*
