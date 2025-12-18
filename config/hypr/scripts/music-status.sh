#!/bin/bash
command -v playerctl &>/dev/null || exit 0

STATUS=$(playerctl status 2>/dev/null)
[ "$STATUS" != "Playing" ] && [ "$STATUS" != "Paused" ] && exit 0

ARTIST=$(playerctl metadata artist 2>/dev/null)
TITLE=$(playerctl metadata title 2>/dev/null)
[ -z "$ARTIST" ] || [ -z "$TITLE" ] && exit 0

[ "$STATUS" = "Playing" ] && ICON="󰝚" || ICON="󰏤"

[ ${#ARTIST} -gt 20 ] && ARTIST="${ARTIST:0:17}..."
[ ${#TITLE} -gt 25 ] && TITLE="${TITLE:0:22}..."

echo "$ICON $ARTIST - $TITLE"
