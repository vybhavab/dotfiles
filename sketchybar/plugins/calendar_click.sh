#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

ICAL="$HOME/.local/bin/ical"
HOVER="$CONFIG_DIR/plugins/popup_hover.sh"

# Remove old popup items before rebuilding
sketchybar --remove '/calendar\..*/' 2>/dev/null

# Fetch tomorrow's events
EVENTS=$("$ICAL" list --from tomorrow --to tomorrow --output json --exclude-calendar "Daily Scheduling" 2>/dev/null)

# Toggle popup
sketchybar --set calendar popup.drawing=toggle

# Header
sketchybar --add item calendar.header popup.calendar \
           --set calendar.header \
                 icon="Tomorrow" \
                 icon.font="SF Pro:Bold:14.0" \
                 icon.color=$WHITE \
                 icon.padding_left=10 \
                 icon.padding_right=10 \
                 label.drawing=off \
                 background.drawing=off \
                 padding_left=4 \
                 padding_right=4

if [[ -z "$EVENTS" ]] || [[ "$EVENTS" == "[]" ]] || [[ "$EVENTS" == "null" ]]; then
  sketchybar --add item calendar.empty popup.calendar \
             --set calendar.empty \
                   icon="  No events" \
                   icon.font="SF Pro:Regular:12.0" \
                   icon.color=$GREY \
                   label.drawing=off \
                   background.drawing=off \
                   padding_left=4 \
                   padding_right=4
else
  COLORS=($ACCENT_PRIMARY $ACCENT_SECONDARY $ACCENT_TERTIARY $ACCENT_QUATERNARY $CYAN $YELLOW)
  INDEX=0

  echo "$EVENTS" | jq -c '[ .[] | select(.title != "Busy") ] | sort_by(.start_date) | .[]' | while IFS= read -r event; do
    TITLE=$(echo "$event" | jq -r '.title // "No Title"')
    START_ISO=$(echo "$event" | jq -r '.start_date')
    ALL_DAY=$(echo "$event" | jq -r '.all_day')

    START_EPOCH=$(date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$START_ISO" +%s 2>/dev/null)

    if [[ "$ALL_DAY" == "true" ]]; then
      TIME_STR="All Day"
    else
      TIME_STR=$(date -j -f "%s" "$START_EPOCH" "+%-I:%M %p" 2>/dev/null)
    fi

    [[ ${#TITLE} -gt 28 ]] && TITLE="${TITLE:0:28}…"

    COLOR_IDX=$((INDEX % ${#COLORS[@]}))
    EVENT_COLOR=${COLORS[$COLOR_IDX]}
    ITEM_NAME="calendar.event.$INDEX"

    sketchybar --add item "$ITEM_NAME" popup.calendar \
               --subscribe "$ITEM_NAME" mouse.entered mouse.exited \
               --set "$ITEM_NAME" \
                     icon="┃ $TIME_STR" \
                     icon.font="SF Pro:Medium:12.0" \
                     icon.color="$EVENT_COLOR" \
                     icon.padding_left=12 \
                     icon.padding_right=4 \
                     label="$TITLE" \
                     label.font="SF Pro:Regular:12.0" \
                     label.color=$WHITE \
                     label.padding_left=4 \
                     label.padding_right=10 \
                     background.drawing=off \
                     padding_left=0 \
                     padding_right=0 \
                     script="$HOVER" \
                     click_script="open -a 'Notion Calendar' && sketchybar --set calendar popup.drawing=off"

    INDEX=$((INDEX + 1))
  done
fi

# Separator
sketchybar --add item calendar.sep popup.calendar \
           --set calendar.sep \
                 icon="─────────────────────" \
                 icon.font="SF Pro:Regular:8.0" \
                 icon.color=$GREY \
                 label.drawing=off \
                 background.drawing=off \
                 padding_left=4 \
                 padding_right=4

# Open Notion Calendar
sketchybar --add item calendar.open popup.calendar \
           --subscribe calendar.open mouse.entered mouse.exited \
           --set calendar.open \
                 icon="󰃭" \
                 icon.font="Symbols Nerd Font:Regular:14.0" \
                 icon.color=$ACCENT_PRIMARY \
                 icon.padding_left=10 \
                 label="Notion Calendar" \
                 label.font="SF Pro:Medium:12.0" \
                 label.color=$WHITE \
                 label.padding_left=6 \
                 label.padding_right=10 \
                 background.drawing=off \
                 padding_left=4 \
                 padding_right=4 \
                 script="$HOVER" \
                 click_script="open -a 'Notion Calendar' && sketchybar --set calendar popup.drawing=off"
