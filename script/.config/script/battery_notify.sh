#!/bin/bash

BAT_PATH=""
for battery in /sys/class/power_supply/BAT*; do
    if [[ -r "$battery/capacity" && -r "$battery/status" ]]; then
        BAT_PATH="$battery"
        break
    fi
done

[ -z "$BAT_PATH" ] && exit 0

read -r battery_percentage < "$BAT_PATH/capacity"
read -r battery_status < "$BAT_PATH/status"

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/battery-notify"
mkdir -p -- "$STATE_DIR" || exit 1
LOW_ALERTED="$STATE_DIR/low-alerted"
HIGH_ALERTED="$STATE_DIR/high-alerted"

play_sound() {
    SOUND="/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"

    command -v paplay >/dev/null && paplay "$SOUND" && return
    command -v aplay  >/dev/null && aplay  "$SOUND"
}

send_alert_once() {
    local marker="$1" urgency="$2" title="$3" message="$4"
    [[ -e "$marker" ]] && return 0

    if notify-send -u "$urgency" "$title" "$message"; then
        : > "$marker"
        play_sound
    fi
}

if [[ "$battery_status" == "Charging" || "$battery_status" == "Full" ]]; then
    rm -f -- "$LOW_ALERTED"
elif (( battery_percentage <= 35 )); then
    send_alert_once "$LOW_ALERTED" critical "Battery Low" "Battery Percentage: $battery_percentage%"
elif (( battery_percentage > 40 )); then
    # Reset above 40% to prevent repeated alerts around the 35% threshold.
    rm -f -- "$LOW_ALERTED"
fi

if [[ "$battery_status" == "Charging" ]] && (( battery_percentage >= 85 )); then
    send_alert_once "$HIGH_ALERTED" normal "Battery High" "Battery Percentage: $battery_percentage% Unplug Charger"
elif [[ "$battery_status" != "Charging" ]] || (( battery_percentage <= 80 )); then
    # Alert again only after unplugging or dropping to 80% or lower.
    rm -f -- "$HIGH_ALERTED"
fi
