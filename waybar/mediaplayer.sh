#!/bin/bash

# Function to escape ampersands
escape_ampersands() {
    echo "$1" | sed -e 's/&/&amp;/g' -e 's/,/\ /g'
}

# Use playerctl with --follow to monitor changes
playerctl --follow metadata --format '{{ artist }} - {{ title }}' 2>/dev/null | while read -r line; do
    # Check if the line contains valid metadata
    if [[ -n "$line" ]]; then
        # Escape ampersands in artist and title
        escaped_line=$(escape_ampersands "$line")
        echo "$escaped_line"
    fi
done

