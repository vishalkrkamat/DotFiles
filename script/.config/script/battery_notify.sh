#!/bin/bash

# Run acpi command and store the output
acpi_output=$(acpi)

# Extract battery percentage using grep and awk, then remove the percentage sign
battery_percentage=$(echo "$acpi_output" | grep -o "[0-9]\{1,3\}%" | awk '{print $1}' | tr -d '%')

# Check if battery percentage is 50% or lower
if [ "$battery_percentage" -le 50 ]; then
    # Check if the laptop is charging
    if [[ "$acpi_output" =~ "Charging" ]]; then
        echo "Battery is charging. No need to notify."
    else
        # Display notification using notify-send
        notify-send "Battery Low" "Battery Percentage: $battery_percentage%"
    fi
else
    echo "Battery Percentage: $battery_percentage%"
fi

