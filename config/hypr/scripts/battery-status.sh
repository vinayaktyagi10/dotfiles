#!/bin/bash
BAT_DIR=$(find /sys/class/power_supply -name "BAT*" -type d | head -1)
[ -z "$BAT_DIR" ] && exit 0

CAPACITY=$(cat "$BAT_DIR/capacity" 2>/dev/null)
STATUS=$(cat "$BAT_DIR/status" 2>/dev/null)
[ -z "$CAPACITY" ] && exit 0

if [ "$STATUS" = "Charging" ]; then
    ICON="󰂄"
elif [ "$CAPACITY" -le 20 ]; then
    ICON="󰂎"
elif [ "$CAPACITY" -le 50 ]; then
    ICON="󰁾"
else
    ICON="󰁹"
fi

echo "$ICON $CAPACITY%"
