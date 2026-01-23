#!/bin/bash
STATE_FILE="$HOME/.cache/wallpaper_state"

# Ensure swww daemon is running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Restore Wallpaper
if [ -f "$STATE_FILE" ]; then
    source "$STATE_FILE"
    if [ ! -z "$WALL_PATH" ]; then
        echo "Restoring wallpaper: $WALL_PATH"
        swww img "$WALL_PATH"
    fi
else
    echo "No wallpaper state found."
fi