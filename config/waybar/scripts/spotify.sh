#!/bin/bash

status=$(playerctl --player=spotify status 2>/dev/null)

# Define icons
play_icon=""
pause_icon=""
spotify_icon=""

# Colors (adjust in Waybar CSS if needed)
color="#1DB954"  # Spotify green

if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
    artist=$(playerctl --player=spotify metadata artist)
    title=$(playerctl --player=spotify metadata title)

    # Truncate if too long
    max_length=40
    full_text="$artist - $title"
    short_text=$(echo "$full_text" | sed -E "s/^(.{0,$max_length})(.*)/\1.../")

    icon="$([[ $status == "Playing" ]] && echo "$play_icon" || echo "$pause_icon")"
    text="$icon $short_text"
    tooltip="$full_text"
else
    text="$spotify_icon  Not playing"
    tooltip="Spotify is not running or no track is active"
fi

# Output valid JSON
jq -c -n --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'

