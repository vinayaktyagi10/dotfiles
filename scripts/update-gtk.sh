#!/bin/bash
# Sync Pywal colors to GTK

# Import colors
source "$HOME/.cache/wal/colors.sh"

# Variables
GTK2_FILE="$HOME/.gtkrc-2.0"
GTK3_FILE="$HOME/.config/gtk-3.0/settings.ini"
GTK4_DIR="$HOME/.config/gtk-4.0"
GTK4_FILE="$GTK4_DIR/settings.ini"

# Create directories
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$GTK4_DIR"

# Apply to GTK3
# We are writing a minimal settings file that forces the Dark theme and standard font
cat > "$GTK3_FILE" <<EOF
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Rubik 11
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

# Apply to GTK4 (Link GTK3 settings)
cp "$GTK3_FILE" "$GTK4_FILE"

# Apply to GTK2
cat > "$GTK2_FILE" <<EOF
gtk-theme-name="Adwaita-dark"
gtk-icon-theme-name="Papirus-Dark"
gtk-font-name="Rubik 11"
gtk-cursor-theme-name="Bibata-Modern-Classic"
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

# Notify
notify-send "GTK Theme" "Reloaded settings (Dark Mode)"
