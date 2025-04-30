#!/bin/bash

# Check if workspace name is provided
if [ -z "$1" ]; then
  echo "Error: Workspace name required"
  exit 1
fi

WORKSPACE="$1"

# Function to move mouse to the center of the focused window or monitor
move_mouse_to_focus() {
  # First try to center on the focused window, if that fails, center on the monitor
  aerospace move-mouse --fail-if-noop window-lazy-center || aerospace move-mouse monitor-lazy-center
}

# Check if the workspace exists on any monitor
if aerospace list-workspaces --all | grep -Fx "$WORKSPACE" > /dev/null; then
  # Workspace exists, check if it's empty
  if aerospace list-workspaces --monitor all --empty | grep -Fx "$WORKSPACE" > /dev/null; then
    # Workspace is empty
    # Check if it's already visible on any monitor
    if aerospace list-workspaces --monitor all --visible | grep -Fx "$WORKSPACE" > /dev/null; then
      # Empty workspace is already visible on some monitor, just switch to it
      echo "Empty workspace $WORKSPACE is already visible, switching to it"
      aerospace workspace "$WORKSPACE"
      # Move mouse to the center of the workspace
      move_mouse_to_focus
    else
      # Empty workspace exists but is not visible, summon it to focused monitor
      echo "Empty workspace $WORKSPACE exists but is not visible, summoning to focused monitor"
      aerospace summon-workspace "$WORKSPACE"
      # Move mouse to the center of the workspace
      move_mouse_to_focus
    fi
  else
    # Workspace is not empty, switch to it on whatever monitor it's on
    echo "Non-empty workspace $WORKSPACE exists, switching to it on its current monitor"
    aerospace workspace "$WORKSPACE"
    # Move mouse to the center of the workspace
    move_mouse_to_focus
  fi
else
  # Workspace doesn't exist, summon it to the focused monitor
  echo "Workspace $WORKSPACE doesn't exist, summoning it to focused monitor"
  aerospace summon-workspace "$WORKSPACE"
  # Move mouse to the center of the workspace
  move_mouse_to_focus
fi
