#!/bin/sh
# This wrapper makes sure that all urxvtc instances
# are handled by a single, lazy-loaded urxvtd daemon
# default to ~
cd $HOME

# If everything went well, urxvtc returns with an exit status of 0.
# If contacting the daemon fails, it exits with the exit status 2.
# In all other error cases it returns with status 1.
urxvtc "$@"
if [ $? -eq 2 ]; then
	urxvtd -q -o -f
	urxvtc "$@"
fi
