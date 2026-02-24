#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
  mouse.entered)
    sketchybar --set "$NAME" background.drawing=on \
                             background.color=$BACKGROUND_2 \
                             background.corner_radius=4 \
                             background.height=22
    ;;
  mouse.exited)
    sketchybar --set "$NAME" background.drawing=off
    ;;
esac
