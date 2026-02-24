#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Check for ethernet first (USB-C adapters on M4 Pro)
ETHERNET_CONNECTED=false
for iface in en5 en6 en7 en8; do
  ETH_IP=$(ifconfig "$iface" 2>/dev/null | grep "inet " | awk '{print $2}' | head -1)
  if [[ -n "$ETH_IP" && "$ETH_IP" != "127.0.0.1" ]]; then
    ETHERNET_CONNECTED=true
    break
  fi
done

if [[ "$ETHERNET_CONNECTED" == true ]]; then
  ICON="󰈀"
  COLOR=$ACCENT_SECONDARY
  sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label.drawing=off
  exit 0
fi

# Check WiFi (en0)
WIFI_CONNECTED=false
WIFI_IP=$(ifconfig en0 2>/dev/null | grep "inet " | awk '{print $2}' | head -1)
if [[ -n "$WIFI_IP" && "$WIFI_IP" != "127.0.0.1" ]]; then
  WIFI_INFO=$(networksetup -getairportnetwork en0 2>/dev/null)
  if [[ "$WIFI_INFO" != *"You are not associated"* ]] && [[ "$WIFI_INFO" != *"not found"* ]]; then
    WIFI_CONNECTED=true
  fi
fi

if [[ "$WIFI_CONNECTED" == true ]]; then
  ICON="󰤨"
  COLOR=$ACCENT_SECONDARY
else
  ICON="󰤭"
  COLOR=$GREY
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label.drawing=off
