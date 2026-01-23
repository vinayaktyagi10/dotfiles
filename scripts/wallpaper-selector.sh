#!/usr/bin/env python3
import os
import sys
import subprocess

# Configuration
wallpaper_dir = os.path.expanduser("~/Pictures/Wallpapers")
rofi_cmd = [
    "rofi", 
    "-dmenu", 
    "-i", 
    "-p", "Wallpaper", 
    "-theme-str", "element-icon { size: 128px; } listview { columns: 4; lines: 3; } element { orientation: vertical; children: [ element-icon, element-text ]; } element-text { horizontal-align: 0.5; }"
]

def get_images(directory):
    extensions = {'.jpg', '.jpeg', '.png', '.webp', '.gif'}
    files = []
    for root, _, filenames in os.walk(directory):
        for f in filenames:
            if os.path.splitext(f)[1].lower() in extensions:
                files.append(os.path.join(root, f))
    return sorted(files)

def select_wallpaper(images):
    # Generate Rofi input
    input_str = ""
    for img in images:
        name = os.path.basename(img)
        # Escape pango markup if necessary (minimal escaping)
        name = name.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
        input_str += f"{name}\0icon\x1f{img}\n"

    try:
        # Run Rofi
        result = subprocess.run(
            rofi_cmd,
            input=input_str,
            text=True,
            capture_output=True
        )
        
        selected_name = result.stdout.strip()
        if not selected_name:
            return None

        # Map back to full path
        for img in images:
            if os.path.basename(img) == selected_name:
                return img
        return None
    except Exception as e:
        print(f"Error running Rofi: {e}")
        return None

def apply_wallpaper(path):
    if not path:
        return

    print(f"Applying: {path}")
    
    # 1. Update Wallpaper (SWWW)
    # Check if daemon is running
    try:
        subprocess.run(["pgrep", "-x", "swww-daemon"], check=True, stdout=subprocess.DEVNULL)
    except subprocess.CalledProcessError:
        subprocess.Popen(["swww-daemon"])
        import time
        time.sleep(0.5)

    subprocess.run(["swww", "img", path, "--transition-type", "random", "--transition-step", "90", "--transition-duration", "2"])

    # 2. Generate Colors (Pywal) -n skips setting wallpaper since swww does it
    subprocess.run(["wal", "-i", path, "-n"])

    # 3. Reload GTK
    gtk_script = os.path.expanduser("~/.scripts/update-gtk.sh")
    if os.path.exists(gtk_script):
        subprocess.run([gtk_script])

    # 4. Reload Waybar
    subprocess.run(["killall", "waybar"], stderr=subprocess.DEVNULL)
    subprocess.Popen([os.path.expanduser("~/.scripts/waybar-launch.sh")])

    # 5. Notify
    subprocess.run(["notify-send", "Wallpaper Changed", f"Set to {os.path.basename(path)}"])

if __name__ == "__main__":
    if not os.path.isdir(wallpaper_dir):
        subprocess.run(["notify-send", "Error", f"Directory not found: {wallpaper_dir}"])
        sys.exit(1)

    images = get_images(wallpaper_dir)
    selected = select_wallpaper(images)
    apply_wallpaper(selected)