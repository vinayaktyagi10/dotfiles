#!/bin/bash
echo "Installing dotfiles..."
ln -sf ~/dotfiles/config/hypr ~/.config/hypr
ln -sf ~/dotfiles/config/waybar ~/.config/waybar
ln -sf ~/dotfiles/config/kitty ~/.config/kitty
ln -sf ~/dotfiles/config/foot ~/.config/foot
ln -sf ~/dotfiles/config/rofi ~/.config/rofi
echo "Dotfiles installed successfully!"
