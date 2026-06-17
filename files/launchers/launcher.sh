#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
## Modified for unification

# XDG Paths
ROFI_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
LAUNCHER_DIR="$ROFI_CONFIG_DIR/launchers"

# Default values
type="type-1"
style="style-1"

# Help message
show_help() {
    echo "Usage: launcher.sh [options]"
    echo ""
    echo "Options:"
    echo "  -t, --type TYPE    Launcher type (e.g., type-1, type-2, ...) [default: $type]"
    echo "  -s, --style STYLE  Launcher style (e.g., style-1, style-2, ...) [default: $style]"
    echo "  -h, --help         Show this help message"
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--type) type="$2"; shift ;;
        -s|--style) style="$2"; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
    esac
    shift
done

theme_file="$LAUNCHER_DIR/$type/$style.rasi"

if [[ ! -f "$theme_file" ]]; then
    echo "Error: Theme file not found: $theme_file"
    exit 1
fi

## Run
rofi \
    -show drun \
    -theme "$theme_file"
