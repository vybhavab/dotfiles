#!/usr/bin/env bash

# Debounce: skip if we restarted within the last 5 seconds
LOCK_FILE="/tmp/sketchybar_restart_lock"
if [ -f "$LOCK_FILE" ]; then
  last=$(cat "$LOCK_FILE")
  now=$(date +%s)
  if (( now - last < 5 )); then
    exit 0
  fi
fi
date +%s > "$LOCK_FILE"

# Restart sketchybar
brew services restart sketchybar
