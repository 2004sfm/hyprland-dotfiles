#!/bin/bash

# Default directory for screenshots (created if it doesn't exist)
PICTURES_DIR=$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")
SAVE_DIR="$PICTURES_DIR/Screenshots"
mkdir -p "$SAVE_DIR"

# Filename based on date and time
FILENAME="$SAVE_DIR/$(date +'%Y-%m-%d_%H-%M-%S_grim.png')"

MODE=$1
CLIPBOARD=$2

case "$MODE" in
    output)
        # Direct capture using grim (native Wayland tool)
        if [ "$CLIPBOARD" = "--clipboard-only" ]; then
            grim - | wl-copy
            notify-send "Screenshot" "Monitor copied to clipboard" -i camera-photo
        else
            grim "$FILENAME"
            notify-send "Screenshot" "Monitor saved" -i camera-photo
        fi
        ;;
    window)
        # Calculate active window geometry using hyprctl (no click required)
        ACTIVE_WINDOW=$(hyprctl activewindow -j)
        if [ "$ACTIVE_WINDOW" = "{}" ]; then
            notify-send "Error" "No active window found" -i dialog-error
            exit 1
        fi
        GEOM=$(echo "$ACTIVE_WINDOW" | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        
        if [ "$CLIPBOARD" = "--clipboard-only" ]; then
            grim -g "$GEOM" - | wl-copy
            notify-send "Screenshot" "Window copied to clipboard" -i camera-photo
        else
            grim -g "$GEOM" "$FILENAME"
            notify-send "Screenshot" "Window saved" -i camera-photo
        fi
        ;;
    region)
        # Use slurp with custom flags and the newly implemented -A center flag
        GEOM=$(slurp -d -t FFFFFFFF -T 000000A0 -A center)
        
        # Handle ESC: if GEOM is empty, exit silently without notifications
        if [ -z "$GEOM" ]; then
            exit 0
        fi
        
        # FIX: Crucial sleep to prevent race condition with the compositor 
        # (ensures slurp's UI overlay is cleared before capturing)
        sleep 0.2
        
        if [ "$CLIPBOARD" = "--clipboard-only" ]; then
            grim -g "$GEOM" - | wl-copy
            notify-send "Screenshot" "Region copied to clipboard" -i camera-photo
        else
            grim -g "$GEOM" "$FILENAME"
            notify-send "Screenshot" "Region saved to $(basename "$FILENAME")" -i camera-photo
        fi
        ;;
    *)
        echo "Usage: $0 {output|window|region} [--clipboard-only]"
        exit 1
        ;;
esac
