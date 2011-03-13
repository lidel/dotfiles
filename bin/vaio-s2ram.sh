#!/bin/bash
XMONAD_DBUS_SESSION_BUS_ADDRESS=`cat /proc/$(pgrep xmonad)/environ | xargs -0 -n1 | grep ^DBUS_SESSION_BUS | xargs`
sudo -u lidel DBUS_SESSION_BUS_ADDRESS=$XMONAD_DBUS_SESSION_BUS_ADDRESS dbus-send --session --type=method_call --dest=org.psi-im.Psi /Main org.psi_im.Psi.Main.sleep &>/dev/null
sudo pm-suspend --quirk-vbe-post
vaio-backlight-raw.sh 7
#DBUS_SESSION_BUS_ADDRESS=$XMONAD_DBUS_SESSION_BUS_ADDRESS dbus-send --session --type=method_call --dest=org.psi-im.Psi /Main org.psi_im.Psi.Main.wake &>/dev/null

