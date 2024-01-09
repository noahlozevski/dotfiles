#!/bin/zsh

# Path to yabai configuration
yabai_config=~/.config/yabai/yabairc

# Get the name of the currently focused application
frontApp=$(osascript -e 'tell application "System Events"' -e 'set frontApp to name of first application process whose frontmost is true' -e 'end tell')

# Escape special characters for regex
escapedApp=$(echo "$frontApp" | sed 's/[]\/$*.^[]/\\&/g')

# Check if the app is already in the blacklist
if ! grep -q "app=\"^$escapedApp\$\" manage=off" "$yabai_config"; then
    # Add a rule to yabairc to blacklist the application
    echo "yabai -m rule --add app=\"^$escapedApp\$\" manage=off" >> "$yabai_config"

    # Reload yabai configuration
    yabai --restart-service
fi
