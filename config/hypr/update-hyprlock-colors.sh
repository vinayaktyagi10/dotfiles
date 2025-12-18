#!/bin/bash

# Hyprlock Pywal Color Integration Script
# Updates hyprlock colors dynamically based on pywal theme
# Save as: ~/.config/hypr/update-hyprlock-colors.sh

# Source pywal colors
if [ ! -f ~/.cache/wal/colors.sh ]; then
  echo "Error: Pywal colors not found. Run 'wal -i <wallpaper>' first."
  exit 1
fi

source ~/.cache/wal/colors.sh

# Convert hex to rgba with alpha
hex_to_rgba() {
  local hex=$1
  local alpha=${2:-1.0}

  # Remove # if present
  hex=${hex#\#}

  # Convert to RGB
  r=$((16#${hex:0:2}))
  g=$((16#${hex:2:2}))
  b=$((16#${hex:4:2}))

  echo "rgba($r,$g,$b,$alpha)"
}

# Get colors with proper alpha values
bg_color=$(hex_to_rgba "$color0" 0.75)
accent_color=$(hex_to_rgba "$color2" 0.2)
text_color=$(hex_to_rgba "$foreground" 0.95)
success_color=$(hex_to_rgba "$color2" 1.0)
error_color=$(hex_to_rgba "$color1" 1.0)
border_color=$(hex_to_rgba "$color7" 0.15)

# Extract RGB values for simple color fields
accent_rgb="${color2#\#}"
success_rgb="${color2#\#}"
error_rgb="${color1#\#}"
text_rgb="${foreground#\#}"

echo "Updating hyprlock colors..."
echo "  Background: $bg_color"
echo "  Accent: $accent_color"
echo "  Success: $success_rgb"
echo "  Error: $error_rgb"

# Create the config with dynamic colors
cat >~/.config/hypr/hyprlock.conf <<EOF
# ══════════════════════════════════════════════════════════════
# 🌈 Hyprlock Configuration - Pywal Dynamic Theme
# Auto-generated from pywal colors
# Generated: $(date)
# ══════════════════════════════════════════════════════════════

# ─── General Settings ─────────────────────────────────────────
general {
    disable_loading_bar = false
    hide_cursor = true
    grace = 2
    no_fade_in = false
    no_fade_out = false
    ignore_empty_input = false
    fade_in_speed = 0.2
    fade_out_speed = 0.25
}

# ─── Background ───────────────────────────────────────────────
background {
    monitor =
    path = screenshot
    blur_passes = 6
    blur_size = 10
    noise = 0.015
    contrast = 0.92
    brightness = 0.75
    vibrancy = 0.25
    vibrancy_darkness = 0.2
    vignette = 0.25
}

# ─── Input Field ──────────────────────────────────────────────
input-field {
    monitor =
    size = 340, 60
    outline_thickness = 2.5
    rounding = 14
    dots_size = 0.35
    dots_spacing = 0.2
    dots_center = true
    dots_rounding = -1
    
    outer_color = $border_color
    inner_color = $bg_color
    font_color = rgb($text_rgb)
    
    fade_on_empty = true
    fade_timeout = 1000
    placeholder_text = <span foreground="##cccccc"><i>  Enter Password...</i></span>
    hide_input = false
    
    check_color = rgb($success_rgb)
    fail_color = rgb($error_rgb)
    fail_text = <span foreground="##$error_rgb"><b>✗ Incorrect</b></span> <span foreground="##888888">(\$ATTEMPTS)</span>
    fail_timeout = 2000
    
    position = 0, -140
    halign = center
    valign = center
    
    shadow_passes = 3
    shadow_size = 10
    shadow_color = rgba(0,0,0,0.6)
    shadow_boost = 1.5
}

# ─── Time Display ─────────────────────────────────────────────
label {
    monitor =
    text = cmd[update:1000] echo "<b>\$(date +"%-I:%M")</b>"
    color = $text_color
    font_size = 120
    font_family = JetBrains Mono Nerd Font
    position = 0, 260
    halign = center
    valign = center
    
    shadow_passes = 3
    shadow_size = 15
    shadow_color = rgba(0,0,0,0.7)
    shadow_boost = 1.8
}

# ─── AM/PM Indicator ──────────────────────────────────────────
label {
    monitor =
    text = cmd[update:1000] echo "\$(date +"%p")"
    color = rgba(200,200,200,0.8)
    font_size = 32
    font_family = JetBrains Mono Nerd Font
    position = 0, 180
    halign = center
    valign = center
    
    shadow_passes = 2
    shadow_size = 8
    shadow_color = rgba(0,0,0,0.5)
}

# ─── Date Display ─────────────────────────────────────────────
label {
    monitor =
    text = cmd[update:60000] echo "\$(date +'%A, %B %-d, %Y')"
    color = rgba(200,200,200,0.85)
    font_size = 24
    font_family = Rubik
    position = 0, 120
    halign = center
    valign = center
    
    shadow_passes = 2
    shadow_size = 8
    shadow_color = rgba(0,0,0,0.6)
}

# ─── User Greeting ────────────────────────────────────────────
label {
    monitor =
    text = cmd[update:300000] echo "👋 <i>Welcome back,</i> <b>\$USER</b>"
    color = $text_color
    font_size = 22
    font_family = Rubik
    position = 0, -260
    halign = center
    valign = center
    
    shadow_passes = 2
    shadow_size = 6
    shadow_color = rgba(0,0,0,0.5)
}

# ─── Spotify/Music Now Playing ────────────────────────────────
label {
    monitor =
    text = cmd[update:2000] bash -c '
        if playerctl status 2>/dev/null | grep -qE "Playing|Paused"; then
            status=\$(playerctl status 2>/dev/null)
            artist=\$(playerctl metadata artist 2>/dev/null)
            title=\$(playerctl metadata title 2>/dev/null)
            
            if [ "\$status" = "Playing" ]; then
                icon="󰝚"
            else
                icon="󰏤"
            fi
            
            if [ \${#artist} -gt 20 ]; then artist="\${artist:0:17}..."; fi
            if [ \${#title} -gt 30 ]; then title="\${title:0:27}..."; fi
            
            if [ -n "\$artist" ] && [ -n "\$title" ]; then
                echo "<span foreground=\"##$accent_rgb\">\$icon</span>  <b>\$artist</b>  <span foreground=\"##888888\">·</span>  \$title"
            fi
        fi
    '
    color = rgba(248,248,242,0.85)
    font_size = 16
    font_family = Rubik
    position = 0, 80
    halign = center
    valign = bottom
    
    shadow_passes = 2
    shadow_size = 8
    shadow_color = rgba(0,0,0,0.6)
}

# ─── Battery Status ───────────────────────────────────────────
label {
    monitor =
    text = cmd[update:5000] bash -c '
        capacity=\$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)
        status=\$(cat /sys/class/power_supply/BAT*/status 2>/dev/null)
        
        if [ -n "\$capacity" ]; then
            if [ "\$status" = "Charging" ]; then
                icon="󰂄"
                color="##$success_rgb"
            elif [ "\$capacity" -le 20 ]; then
                icon="󰂎"
                color="##$error_rgb"
            elif [ "\$capacity" -le 50 ]; then
                icon="󰁾"
                color="##f1fa8c"
            else
                icon="󰁹"
                color="##$success_rgb"
            fi
            echo "<span foreground=\"\$color\">\$icon</span>  \$capacity%"
        else
            echo ""
        fi
    '
    color = rgba(200,200,200,0.85)
    font_size = 16
    font_family = JetBrains Mono Nerd Font
    position = 20, 30
    halign = right
    valign = bottom
    
    shadow_passes = 2
    shadow_size = 5
    shadow_color = rgba(0,0,0,0.5)
}

# ─── Network Status ───────────────────────────────────────────
label {
    monitor =
    text = cmd[update:5000] bash -c '
        if ping -c 1 8.8.8.8 &>/dev/null; then
            ssid=\$(nmcli -t -f active,ssid dev wifi | grep "^yes" | cut -d: -f2)
            if [ -n "\$ssid" ]; then
                echo "<span foreground=\"##$success_rgb\">󰖨</span>  \$ssid"
            else
                echo "<span foreground=\"##$success_rgb\">󰈀</span>  Connected"
            fi
        else
            echo "<span foreground=\"##$error_rgb\">󰖪</span>  Offline"
        fi
    '
    color = rgba(200,200,200,0.85)
    font_size = 16
    font_family = JetBrains Mono Nerd Font
    position = -20, 30
    halign = left
    valign = bottom
    
    shadow_passes = 2
    shadow_size = 5
    shadow_color = rgba(0,0,0,0.5)
}

# ─── System Uptime ────────────────────────────────────────────
label {
    monitor =
    text = cmd[update:60000] bash -c '
        uptime=\$(uptime -p | sed "s/up //;s/ hours/h/;s/ hour/h/;s/ minutes/m/;s/ minute/m/")
        echo "<span foreground=\"##$accent_rgb\">󰔟</span>  \$uptime"
    '
    color = rgba(150,150,150,0.75)
    font_size = 14
    font_family = JetBrains Mono Nerd Font
    position = 20, 55
    halign = right
    valign = bottom
    
    shadow_passes = 2
    shadow_size = 4
    shadow_color = rgba(0,0,0,0.4)
}

# ─── Keyboard Layout ──────────────────────────────────────────
label {
    monitor =
    text = cmd[update:1000] bash -c '
        layout=\$(hyprctl devices -j | jq -r ".keyboards[0].active_keymap" 2>/dev/null | head -c 2 | tr "[:lower:]" "[:upper:]")
        [ -n "\$layout" ] && echo "󰌌  \$layout" || echo ""
    '
    color = rgba(150,150,150,0.7)
    font_size = 14
    font_family = JetBrains Mono Nerd Font
    position = -20, 55
    halign = left
    valign = bottom
    
    shadow_passes = 2
    shadow_size = 4
    shadow_color = rgba(0,0,0,0.4)
}
EOF

echo "✓ Hyprlock config updated with pywal colors!"
echo "  Lock screen with: hyprlock (or Super+L)"
