#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Dismiss popup on click-outside
if [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set mic popup.drawing=off
  exit 0
fi

MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)' 2>/dev/null)
CURRENT_MIC=$(SwitchAudioSource -c -t input 2>/dev/null)

# Truncate mic name for display
if [[ ${#CURRENT_MIC} -gt 15 ]]; then
  MIC_LABEL="${CURRENT_MIC:0:15}…"
else
  MIC_LABEL="$CURRENT_MIC"
fi

if [[ -z "$MIC_VOLUME" ]] || [[ "$MIC_VOLUME" -eq 0 ]]; then
  ICON="󰍭"
  COLOR=$RED
else
  ICON="󰍬"
  COLOR=$ACCENT_SECONDARY
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" \
  label="$MIC_LABEL" label.color="$WHITE"
