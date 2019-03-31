#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
MONITOR=$(polybar -m|head -1|sed -e 's/:.*$//g')
polybar -r top &
polybar -r bottom &
echo "Bars launched..."
