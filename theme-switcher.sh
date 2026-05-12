#!/usr/bin/env bash

set -u

THEME_DIR="$HOME/.config/tmux"

appearance=$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode' 2>/dev/null) || {
  printf 'Failed to detect macOS appearance\n' >&2
  exit 1
}

if [ "$appearance" = "true" ]; then
  selected_theme="dark"
  selected_theme_file="$THEME_DIR/solarized-dark.conf"
elif [ "$appearance" = "false" ]; then
  selected_theme="light"
  selected_theme_file="$THEME_DIR/solarized-light.conf"
else
  printf 'Unexpected macOS appearance value: %s\n' "$appearance" >&2
  exit 1
fi

active_theme=$(tmux show-option -gqv @active_theme_selection)

if [ "${TMUX_THEME_FORCE:-0}" != "1" ] && [ "$selected_theme" = "$active_theme" ]; then
  exit 0
fi

tmux source-file "$selected_theme_file" || exit $?
tmux set-option -gq @active_theme_selection "$selected_theme"
