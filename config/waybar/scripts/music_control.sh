#!/bin/bash

# File to track click count
CLICK_FILE="$HOME/.config/waybar/music_clicks"

# Reset clicks count after 1 second
if [[ -f "$CLICK_FILE" ]]; then
    LAST_CLICK=$(cat "$CLICK_FILE")
else
    LAST_CLICK=0
fi

CURRENT_TIME=$(date +%s)
CLICK_INTERVAL=1  # Time window for counting clicks in seconds
CLICK_COUNT=1  # Default single click

# If last click was within the interval, increment click count
if [[ $((CURRENT_TIME - LAST_CLICK)) -le $CLICK_INTERVAL ]]; then
    CLICK_COUNT=$((CLICK_COUNT + 1))
else
    CLICK_COUNT=1
fi

# Update the last click timestamp
echo $CURRENT_TIME > "$CLICK_FILE"

# Handle click actions
case $CLICK_COUNT in
    1)
        # Single click - mute or unmute
        playerctl volume toggle
        ;;
    2)
        # Double click - next track
        playerctl next
        ;;
    3)
        # Triple click - previous track
        playerctl previous
        ;;
esac

