#!/bin/sh
# Simple Browser Wrapper
# by Marcin Rataj (http://lidel.org)
# Updates: http://github.com/lidel/dotfiles/
# License: public domain

# Features:
#   - more like a convention than an actual script
#   - environment-agnostic browser definition
#   - optional notifications
#
# Installation:
#   export BROWSER="/home/lidel/bin/browser-wrapper.sh"
#   gconftool-2 -s -t string /desktop/gnome/url-handlers/http/command '/home/lidel/bin/browser-wrapper.sh "%s"'
#   gconftool-2 -s -t string /desktop/gnome/url-handlers/https/command '/home/lidel/bin/browser-wrapper.sh "%s"'

## fix empty urls (+new tab in chromium)
URL="$*"; [ -z "$URL" ] && url=about:blank

## I like to know when URL was sent to a browser (osd)
notify-send -u low -t 500 -c 'transfer' "Opening" "$URL" &

## deprecated nitification methods (left as a reference)
#echo "naughty.notify({title = \"URL loading\", text = \"${url}\", timeout = 2, icon = \"/home/lidel/.icons/ALLGREY/18x18/apps/firefox.png\"})" | awesome-client -
#echo -e "\n\nopening: $URL" | osd_cat -p top -A right -c grey75 -O 1 -d 1 &

## firefox (left as a reference)
# try xremote first
#firefox -new-tab "$URL" && exit 0
#firefox -remote "openurl($URL,new-tab)" && exit 0
# if xremote failed, then launch the browser
#exec firefox "$URL"

## chromium
exec chromium "$URL"

