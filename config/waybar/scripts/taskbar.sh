#!/bin/bash

# Check dependencies
if ! command -v task &> /dev/null || ! command -v jq &> /dev/null; then
    echo "{\"text\": \" Deps\", \"tooltip\": \"Missing 'task' (taskwarrior) or 'jq'. Install them to use this module.\", \"class\": \"error\"}"
    exit 0
fi

# Get pending task count
COUNT=$(task status:pending count)

if [ "$COUNT" -gt 0 ]; then
    # Get the most urgent task description for tooltip
    URGENT=$(task status:pending limit:1 export | jq -r '.[0].description // "No description"')
    
    # Escape quotes in description
    URGENT_ESCAPED=$(echo "$URGENT" | sed 's/"/\\"/g')
    
    # Output JSON for Waybar
    echo "{\"text\": \" $COUNT\", \"tooltip\": \"Next: $URGENT_ESCAPED\", \"class\": \"pending\"}"
else
    # Output nothing to hide the module in Waybar
    exit 0
fi