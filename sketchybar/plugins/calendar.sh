#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Dismiss popup on click-outside
if [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set calendar popup.drawing=off
  exit 0
fi

ICAL="$HOME/.local/bin/ical"

# Get today's events as JSON, exclude "Daily Scheduling" routine blocks
EVENTS=$("$ICAL" today --output json --exclude-calendar "Daily Scheduling" 2>/dev/null)

if [[ -z "$EVENTS" ]] || [[ "$EVENTS" == "[]" ]] || [[ "$EVENTS" == "null" ]]; then
  sketchybar --set "$NAME" icon="󰸗" icon.color="$GREY" label="No Events" label.color="$GREY"
  exit 0
fi

NOW=$(date +%s)

# Filter: not "Busy", and end_date is in the future (still active or upcoming)
NEXT=$(echo "$EVENTS" | jq -r --arg now "$NOW" '
  [ .[] | select(.title != "Busy")
        | select((.end_date | strptime("%Y-%m-%dT%H:%M:%SZ") | mktime) > ($now | tonumber)) ] |
  sort_by(.start_date) |
  first // empty
')

if [[ -z "$NEXT" ]] || [[ "$NEXT" == "null" ]]; then
  sketchybar --set "$NAME" icon="󰸗" icon.color="$GREY" label="No Events" label.color="$GREY"
  exit 0
fi

TITLE=$(echo "$NEXT" | jq -r '.title // "No Title"')
START_ISO=$(echo "$NEXT" | jq -r '.start_date')
END_ISO=$(echo "$NEXT" | jq -r '.end_date')

# Parse ISO dates (UTC) to epoch
START_EPOCH=$(date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$START_ISO" +%s 2>/dev/null)
END_EPOCH=$(date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$END_ISO" +%s 2>/dev/null)

if [[ -z "$START_EPOCH" ]]; then
  sketchybar --set "$NAME" icon="󰸗" icon.color="$GREY" label="No Events" label.color="$GREY"
  exit 0
fi

DIFF_MIN=$(( (START_EPOCH - NOW) / 60 ))
# Convert epoch to local time for display (not UTC)
LOCAL_TIME=$(date -j -f "%s" "$START_EPOCH" "+%-I:%M %p" 2>/dev/null)

# Truncate title
[[ ${#TITLE} -gt 20 ]] && TITLE="${TITLE:0:20}…"

# Format based on urgency
if [[ $NOW -ge $START_EPOCH && $NOW -lt $END_EPOCH ]]; then
  LABEL="Now: $TITLE"
  COLOR=$RED
  ICON="󰃭"
elif [[ $DIFF_MIN -le 15 && $DIFF_MIN -ge 0 ]]; then
  LABEL="$TITLE in ${DIFF_MIN}m"
  COLOR=$ORANGE
  ICON="󰃭"
elif [[ $DIFF_MIN -le 60 && $DIFF_MIN -ge 0 ]]; then
  LABEL="$TITLE in ${DIFF_MIN}m"
  COLOR=$YELLOW
  ICON="󰃭"
else
  LABEL="$TITLE · $LOCAL_TIME"
  COLOR=$ACCENT_PRIMARY
  ICON="󰸗"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" \
  label="$LABEL" label.color="$WHITE"
