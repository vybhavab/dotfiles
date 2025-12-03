#!/bin/bash
# XP-Pen ACK05 Controller Installer

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing XP-Pen ACK05 controller..."

# Ensure ~/.local/bin exists
mkdir -p ~/.local/bin

# Copy binary to ~/.local/bin
cp "$SCRIPT_DIR/bin/ack05" ~/.local/bin/ack05
chmod +x ~/.local/bin/ack05

# Install LaunchAgent (user level) - generate with correct $HOME path
sed "s|\$HOME|$HOME|g" "$SCRIPT_DIR/com.vybhavab.xppen-ack05.plist" > ~/Library/LaunchAgents/com.vybhavab.xppen-ack05.plist

# Unload if already loaded, then load
launchctl unload ~/Library/LaunchAgents/com.vybhavab.xppen-ack05.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/com.vybhavab.xppen-ack05.plist

echo ""
echo "Done! ACK05 controller installed and running."
echo "Logs: tail -f /tmp/xppen-ack05.log"
echo ""
echo "To rebuild from source:"
echo "  cd ~/projects/xptool && bun build --compile --outfile ~/.dotfiles/xppen-ack05/bin/ack05 ./index.ts"
echo ""
echo "To uninstall:"
echo "  launchctl unload ~/Library/LaunchAgents/com.vybhavab.xppen-ack05.plist"
echo "  rm ~/Library/LaunchAgents/com.vybhavab.xppen-ack05.plist"
echo "  rm ~/.local/bin/ack05"
