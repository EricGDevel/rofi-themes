#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
## Modified for unification

# XDG Paths
ROFI_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
APPLETS_DIR="$ROFI_CONFIG_DIR/applets"

# Default values
applet="apps"
type="type-1"
style="style-1"

# Help message
show_help() {
    echo "Usage: applet.sh [options]"
    echo ""
    echo "Options:"
    echo "  -a, --applet NAME  Applet name (apps, battery, volume, ...) [default: $applet]"
    echo "  -t, --type TYPE    Applet type (e.g., type-1, type-2, ...) [default: $type]"
    echo "  -s, --style STYLE  Applet style (e.g., style-1, style-2, ...) [default: $style]"
    echo "  -h, --help         Show this help message"
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a|--applet) applet="$2"; shift ;;
        -t|--type) type="$2"; shift ;;
        -s|--style) style="$2"; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Export for sub-scripts to use
export ROFI_APPLETS_TYPE="$type"
export ROFI_APPLETS_STYLE="$style"

# Set theme variable for sub-scripts
export type="$ROFI_CONFIG_DIR/applets/$ROFI_APPLETS_TYPE"
export style="$ROFI_APPLETS_STYLE"
[[ "$style" != *.rasi ]] && style="${style}.rasi"
export theme="$type/$style"

applet_script="$APPLETS_DIR/bin/${applet}.sh"

if [[ ! -f "$applet_script" ]]; then
    # Try without .sh
    applet_script="$APPLETS_DIR/bin/${applet}"
    if [[ ! -f "$applet_script" ]]; then
        echo "Error: Applet script not found: $applet"
        exit 1
    fi
fi

# Run the applet script
bash "$applet_script"
