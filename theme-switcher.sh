#!/bin/bash
# Theme switcher for tmux - detects macOS appearance and loads appropriate Solarized theme

# Get the macOS appearance setting
APPEARANCE=$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode')

# Path to theme files
THEME_DIR="$HOME/.config/tmux"

if [ "$APPEARANCE" = "true" ]; then
    # Dark mode is enabled
    tmux source-file "$THEME_DIR/solarized-dark.conf"
else
    # Light mode is enabled
    tmux source-file "$THEME_DIR/solarized-light.conf"
fi

