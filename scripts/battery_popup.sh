#!/bin/bash

BATTINFO=`acpi -b`
if [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -f 5 -d " "` < 00:15:00 ]] ; then
    DISPLAY=:0.0 notify-send "low battery" "$BATTINFO" -u critical
fi

if [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -f 5 -d " "` < 00:03:00 ]] ; then
    DISPLAY=:0.0 notify-send "Only 3 min of battey left" "$BATTINFO" -u critical
fi
