#!/bin/bash

GPU_DIR="$HOME/.config/hypr/gpu"
ACTIVE_LINK="$HOME/.config/hypr/gpu/active.conf"

# Rofi Command: Gallery Style (2 Columns, Large Icons)
ROFI_CMD="rofi -dmenu -i -p 'GPU Mode' -theme-str 'window {width: 600px;} element-icon { size: 96px; } listview { columns: 2; lines: 1; } element { orientation: vertical; children: [ element-icon, element-text ]; } element-text { horizontal-align: 0.5; }'"

# Options with Icons (using installed icon themes)
# We use 'nvidia' (usually mapped) and 'cpu' generic icon
NVIDIA_OPT="NVIDIA (Performance)\0icon\x1fnvidia"
AMD_OPT="AMD (Power Save)\0icon\x1fcpu"

# Show Menu
CHOICE=$(echo -en "$NVIDIA_OPT\n$AMD_OPT" | eval $ROFI_CMD)

# Logic
case "$CHOICE" in
    *"NVIDIA"*) 
        ln -sf "$GPU_DIR/nvidia.conf" "$ACTIVE_LINK"
        MSG="Switched to NVIDIA. Please Logout."
        ;;
    *"AMD"*) 
        ln -sf "$GPU_DIR/amd.conf" "$ACTIVE_LINK"
        MSG="Switched to AMD. Please Logout."
        ;;
    *) 
        exit 0
        ;;
esac

# Confirm Logout
if echo -e "Yes\nNo" | rofi -dmenu -p "$MSG Logout now?" -theme-str 'window {width: 400px;} listview {lines: 2;}' | grep -q "Yes"; then
    hyprctl dispatch exit
else
    notify-send "GPU Mode" "$MSG"
fi