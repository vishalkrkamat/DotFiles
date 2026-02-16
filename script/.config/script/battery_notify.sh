#!/bin/bash

BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1)

[ -z "$BAT_PATH" ] && exit 0

battery_percentage=$(cat "$BAT_PATH/capacity")
battery_status=$(cat "$BAT_PATH/status")

play_sound() {
    SOUND="/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"

    command -v paplay >/dev/null && paplay "$SOUND" && return
    command -v aplay  >/dev/null && aplay  "$SOUND"
}

if [ "$battery_percentage" -le 50 ]; then
    if [ "$battery_status" = "Charging" ] || [ "$battery_status" = "Full" ]; then
        echo "Battery is charging. No need to notify."
    else
        notify-send -u critical "Battery Low" "Battery Percentage: $battery_percentage%"
        play_sound
    fi
else
    echo "Battery Percentage: $battery_percentage%"
fi

