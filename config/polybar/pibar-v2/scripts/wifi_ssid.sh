#!/bin/bash

# Loop indefinitely
while true; do
    # Get the current Wi-Fi SSID
    SSID=$(iwgetid -r)
    
    # Output the SSID (or a placeholder if empty)
    if [ -z "$SSID" ]; then
        echo "No Wi-Fi"
    else
        echo "$SSID"
    fi
    
    # Wait for 30 seconds before the next check
    sleep 30
done

