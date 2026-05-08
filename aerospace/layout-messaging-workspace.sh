#!/usr/bin/env bash
set -euo pipefail

workspace=5
slack_bundle_id='com.tinyspeck.slackmacgap'
messages_bundle_id='com.apple.MobileSMS'
signal_bundle_id='org.whispersystems.signal-desktop'

# Give AeroSpace a moment to finish moving the newly detected window.
sleep 0.2

slack_id="$(aerospace list-windows --workspace "$workspace" --app-bundle-id "$slack_bundle_id" --format '%{window-id}' | head -n 1)"
messages_id="$(aerospace list-windows --workspace "$workspace" --app-bundle-id "$messages_bundle_id" --format '%{window-id}' | head -n 1)"
signal_id="$(aerospace list-windows --workspace "$workspace" --app-bundle-id "$signal_bundle_id" --format '%{window-id}' | head -n 1)"

if [[ -z "$slack_id" || -z "$messages_id" || -z "$signal_id" ]]; then
  exit 0
fi

monitor_id="$(aerospace list-windows --workspace "$workspace" --format '%{monitor-id}' | head -n 1)"
monitor_name="$(aerospace list-monitors --json | jq -r --argjson id "$monitor_id" '.[] | select(."monitor-id" == $id) | ."monitor-name"')"
base_monitor_name="$(sed -E 's/ \([0-9]+\)$//' <<<"$monitor_name")"

monitor_width="$(
  system_profiler SPDisplaysDataType |
    awk -v monitor="$base_monitor_name" '
      $0 ~ "^[[:space:]]{8}" monitor ":" { in_monitor = 1; next }
      in_monitor && /UI Looks like:/ {
        for (i = 1; i <= NF; i++) {
          if ($i ~ /^[0-9]+$/ && $(i + 1) == "x") {
            print $i
            exit
          }
        }
      }
      in_monitor && /^[[:space:]]{8}[^[:space:]].*:$/ { in_monitor = 0 }
    '
)"

if [[ -z "$monitor_width" ]]; then
  monitor_width=1920
fi

# Match configured left/right outer gaps and two inner gaps on a three-window row.
usable_width=$((monitor_width - 24))
slack_width=$(((usable_width * 6) / 13))
messages_width=$(((usable_width * 4) / 13))
signal_width=$((usable_width - slack_width - messages_width))

aerospace flatten-workspace-tree --workspace "$workspace" || true

aerospace layout --window-id "$slack_id" h_tiles || true
aerospace layout --window-id "$messages_id" h_tiles || true
aerospace layout --window-id "$signal_id" h_tiles || true

# Stable left-to-right order: Slack, Messages, Signal.
for _ in 1 2 3; do
  aerospace swap --window-id "$slack_id" left || true
done
for _ in 1 2 3; do
  aerospace swap --window-id "$signal_id" right || true
done

aerospace resize --window-id "$slack_id" width "$slack_width"
aerospace resize --window-id "$messages_id" width "$messages_width"
aerospace resize --window-id "$signal_id" width "$signal_width"
