#!/bin/sh
export WLR_NO_HARDWARE_CURSORS=1
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_RENDERER=vulkan
export XWAYLAND_NO_GLAMOR=1

# Log output to a file so we can see what happens if it fails
echo "--- Starting Sway at $(date) ---" >> /tmp/sway-startup.log
exec sway --unsupported-gpu >> /tmp/sway-startup.log 2>&1
