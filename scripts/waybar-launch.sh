#!/bin/bash

LOG_FILE="/tmp/waybar.log"

# 1. Self-Cleanup: Kill OLD instances of this script
# We filter for the script name, exclude the current PID ($$), and kill them.
# This stops the 'while true' loop of the previous instance.
for pid in $(pgrep -f "waybar-launch.sh"); do
    if [ "$pid" != "$$" ]; then
        echo "[$(date)] Killing previous script instance: $pid" >> "$LOG_FILE"
        kill "$pid" 2>/dev/null
    fi
done

# 2. Cleanup Waybar: Kill any running waybar instances
# This ensures we start with a clean slate.
echo "[$(date)] Killing running waybar instances..." >> "$LOG_FILE"
killall -q waybar

# 3. Wait for cleanup to complete
# Loop until waybar is truly gone.
while pgrep -u $UID -x waybar >/dev/null; do 
    sleep 0.2
done

echo "--- Starting Waybar (Keep-Alive Mode) ---" | tee -a "$LOG_FILE"

# 4. Start the Keep-Alive Loop
while true; do
    echo "[$(date)] Starting waybar..." >> "$LOG_FILE"
    waybar >> "$LOG_FILE" 2>&1 &
    WAYBAR_PID=$!
    
    # Block and wait for this specific process to exit
    wait $WAYBAR_PID
    
    EXIT_CODE=$?
    echo "[$(date)] Waybar exited with code $EXIT_CODE. Restarting in 1s..." >> "$LOG_FILE"
    sleep 1
done