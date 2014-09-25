#!/bin/sh
# Browser wrapper with popup feedback
# Updates: https://github.com/lidel/dotfiles/blob/master/bin/browser-wrapper.sh
# License: CC0 (Public Domain)
#
# Installation:
#   export BROWSER="/home/lidel/bin/browser-wrapper.sh"
#   gconftool-2 -s -t string /desktop/gnome/url-handlers/http/command '/home/lidel/bin/browser-wrapper.sh "%s"'
#   gconftool-2 -s -t string /desktop/gnome/url-handlers/https/command '/home/lidel/bin/browser-wrapper.sh "%s"'

#export MOZ_GLX_IGNORE_BLACKLIST=1
#export MOZ_DISABLE_PANGO=1
#export VDPAU_DRIVER=softpipe

icon=/home/lidel/.icons/gnome-colors-common/scalable/actions/redo.svg

firefox=/usr/bin/firefox

## fix empty urls
URL="$*"; [ -z "$URL" ] && URL=about:blank

## I like to know when URL was sent to a browser (notify-osd)
notify-send -i $icon -h string:x-canonical-append:browser "Opening URL" "$URL" &

# try xremote first
$firefox -new-tab "$URL" && exit 0
# if xremote failed, then launch the browser
$firefox "$URL"

