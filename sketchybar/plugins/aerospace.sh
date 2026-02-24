#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# The workspace ID this item represents (passed as $1)
SID="$1"

# Get the currently focused workspace from the event variable or query aerospace
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# Update display assignment (handles workspace moves between monitors)
# Read cached NSScreen -> sketchybar arrangement mapping
declare -A ns_to_display
while read -r ns_id arr_id; do
  ns_to_display["$ns_id"]="$arr_id"
done < /tmp/sketchybar_nsscreen_to_display 2>/dev/null

NS_ID=$(aerospace list-workspaces --monitor all --format '%{workspace} %{monitor-appkit-nsscreen-screens-id}' 2>/dev/null \
  | awk -v ws="$SID" '$1 == ws { print $2 }')
DISPLAY_ID="${ns_to_display[$NS_ID]}"
if [ -n "$DISPLAY_ID" ]; then
  sketchybar --set "$NAME" display="$DISPLAY_ID"
fi

if [ "$SID" = "$FOCUSED" ]; then
  # Active workspace — highlighted
  sketchybar --set "$NAME" \
    background.color=$ACCENT_PRIMARY \
    background.border_width=0 \
    icon.color=0xff1a1b26 \
    icon.font="SF Pro:Bold:13.0"
else
  # Inactive workspace — dimmed
  sketchybar --set "$NAME" \
    background.color=$BACKGROUND_1 \
    background.border_width=0 \
    icon.color=$GREY \
    icon.font="SF Pro:Bold:13.0"
fi
