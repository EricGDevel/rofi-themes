#!/usr/bin/env bash

# Common utilities for Rofi themes

ROFI_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"

# Get the list columns and rows based on type
# Usage: get_layout_dims "type-1"
get_layout_dims() {
    local type=$1
    if [[ "$type" == *"type-1"* || "$type" == *"type-3"* || "$type" == *"type-5"* ]]; then
        echo "1 6"
    elif [[ "$type" == *"type-2"* || "$type" == *"type-4"* ]]; then
        echo "6 1"
    else
        echo "1 6" # Default
    fi
}

# Get applet specific dimensions
# Usage: get_applet_dims "type-1" "battery"
get_applet_dims() {
    local type=$1
    local applet=$2
    local col='1'
    local row='6'
    local width='400px'

    case "$type" in
        *"type-1"*) col='1'; row='6'; width='400px' ;;
        *"type-2"*) col='6'; row='1'; width='670px' ;;
        *"type-3"*) col='1'; row='6'; width='120px' ;;
        *"type-4"*) col='6'; row='1'; width='670px' ;;
        *"type-5"*) col='1'; row='6'; width='520px' ;;
    esac

    # Applet specific overrides
    if [[ "$applet" == "battery" ]]; then
        row='4'
        [[ "$type" == *"type-2"* || "$type" == *"type-4"* ]] && col='4'
    elif [[ "$applet" == "volume" ]]; then
        row='5'
        [[ "$type" == *"type-2"* || "$type" == *"type-4"* ]] && col='5'
    fi

    echo "$col $row $width"
}

# Get theme file path
get_theme_path() {
    local category=$1
    local type=$2
    local style=$3
    echo "$ROFI_CONFIG_DIR/$category/$type/$style"
}
