#!/bin/bash

# Script to restart Waybar

# Path to Waybar configuration file
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"

# Check if Waybar is already running
if pgrep -x "waybar" > /dev/null
then
    echo "Waybar is running. Killing the process..."
    # Kill the running Waybar process
    pkill -x "waybar"
    # Wait for the process to be fully terminated
    sleep 1
fi

echo "Starting Waybar..."
# Start Waybar with the specified configuration and style
waybar -c $WAYBAR_CONFIG -s $WAYBAR_STYLE &
echo "Waybar started."
