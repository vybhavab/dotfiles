#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

HOVER="$CONFIG_DIR/plugins/popup_hover.sh"

# Remove old popup items before rebuilding
sketchybar --remove '/mic\..*/' 2>/dev/null

# Toggle popup
sketchybar --set mic popup.drawing=toggle

# Get all input devices
DEVICES=$(SwitchAudioSource -a -t input 2>/dev/null)
CURRENT=$(SwitchAudioSource -c -t input 2>/dev/null)

# Mute toggle
MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)' 2>/dev/null)
if [[ -z "$MIC_VOLUME" ]] || [[ "$MIC_VOLUME" -eq 0 ]]; then
  MUTE_ICON="󰍭"
  MUTE_COLOR=$RED
  MUTE_LABEL="Unmute Mic"
else
  MUTE_ICON="󰍬"
  MUTE_COLOR=$ACCENT_SECONDARY
  MUTE_LABEL="Mute Mic"
fi

sketchybar --add item mic.mute popup.mic \
           --subscribe mic.mute mouse.entered mouse.exited \
           --set mic.mute icon="$MUTE_ICON" \
                         icon.color="$MUTE_COLOR" \
                         icon.font="Symbols Nerd Font:Regular:15.0" \
                         icon.padding_left=10 \
                         label="$MUTE_LABEL" \
                         label.font="SF Pro:Medium:12.0" \
                         label.color=$WHITE \
                         label.padding_left=6 \
                         label.padding_right=10 \
                         background.drawing=off \
                         padding_left=4 \
                         padding_right=4 \
                         script="$HOVER" \
                         click_script="osascript -e 'if input volume of (get volume settings) is 0 then set volume input volume 80 else set volume input volume 0' && sketchybar --set mic popup.drawing=off && $CONFIG_DIR/plugins/mic.sh"

# Separator
sketchybar --add item mic.sep popup.mic \
           --set mic.sep \
                 icon="─────────────────────" \
                 icon.font="SF Pro:Regular:8.0" \
                 icon.color=$GREY \
                 label.drawing=off \
                 background.drawing=off \
                 padding_left=4 \
                 padding_right=4

# Device list
INDEX=0
while IFS= read -r device; do
  [[ -z "$device" ]] && continue
  ITEM_NAME="mic.device.$INDEX"

  if [[ "$device" == "$CURRENT" ]]; then
    DEV_COLOR=$ACCENT_PRIMARY
    DEV_ICON="󰄬"
  else
    DEV_COLOR=$GREY
    DEV_ICON="  "
  fi

  DEV_LABEL="$device"
  [[ ${#DEV_LABEL} -gt 28 ]] && DEV_LABEL="${DEV_LABEL:0:28}…"

  sketchybar --add item "$ITEM_NAME" popup.mic \
             --subscribe "$ITEM_NAME" mouse.entered mouse.exited \
             --set "$ITEM_NAME" icon="$DEV_ICON" \
                               icon.color="$DEV_COLOR" \
                               icon.font="Symbols Nerd Font:Regular:13.0" \
                               icon.padding_left=10 \
                               label="$DEV_LABEL" \
                               label.font="SF Pro:Medium:11.0" \
                               label.color="$DEV_COLOR" \
                               label.padding_left=6 \
                               label.padding_right=10 \
                               background.drawing=off \
                               padding_left=4 \
                               padding_right=4 \
                               script="$HOVER" \
                               click_script="SwitchAudioSource -t input -s '$device' && sketchybar --set mic popup.drawing=off && $CONFIG_DIR/plugins/mic.sh"

  INDEX=$((INDEX + 1))
done <<< "$DEVICES"
