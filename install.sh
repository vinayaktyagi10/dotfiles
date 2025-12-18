#!/bin/bash

# Define paths
DOTFILES_DIR="$HOME/dotfiles/dotfiles"
CONFIG_DIR="$DOTFILES_DIR/config"
TARGET_DIR="$HOME/.config"

# List of configs to link
CONFIGS=(
    "hypr"
    "waybar"
    "kitty"
    "nvim"
    "swaync"
    "wlogout"
    "fuzzel"
    "ghostty"
    "foot"
    "rofi"
)

echo "--- Installing Dotfiles via Symlinks ---"

# Ensure target config directory exists
mkdir -p "$TARGET_DIR"

for config in "${CONFIGS[@]}"; do
    if [ -d "$CONFIG_DIR/$config" ]; then
        echo "Linking: $config"
        # Remove existing directory/link if it exists
        rm -rf "$TARGET_DIR/$config"
        # Create symlink
        ln -sf "$CONFIG_DIR/$config" "$TARGET_DIR/$config"
    else
        echo "Skipping: $config (not found in $CONFIG_DIR)"
    fi
done

# Link single files
if [ -f "$CONFIG_DIR/.zshrc" ]; then
    echo "Linking: .zshrc"
    ln -sf "$CONFIG_DIR/.zshrc" "$HOME/.zshrc"
fi

echo "---------------------------------------"
echo "Installation complete! Configs are now linked to $DOTFILES_DIR"