#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
## Modified for unification and Wayland support

# XDG Paths
ROFI_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
POWERMENU_DIR="$ROFI_CONFIG_DIR/powermenu"

# Default values
type="type-1"
style="style-1"

# Help message
show_help() {
    echo "Usage: powermenu.sh [options]"
    echo ""
    echo "Options:"
    echo "  -t, --type TYPE    Powermenu type (e.g., type-1, type-2, ...) [default: $type]"
    echo "  -s, --style STYLE  Powermenu style (e.g., style-1, style-2, ...) [default: $style]"
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

theme_file="$POWERMENU_DIR/$type/$style.rasi"

if [[ ! -f "$theme_file" ]]; then
    echo "Error: Theme file not found: $theme_file"
    exit 1
fi

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"
host="$(hostname)"

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$host" \
		-mesg "Uptime: $uptime" \
		-theme "$theme_file"
}

# Confirmation CMD
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme "$ROFI_CONFIG_DIR/shared/confirm.rasi"
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
            # Wayland-friendly logout
            if command -v loginctl >/dev/null 2>&1; then
                loginctl terminate-user $USER
            elif [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
				i3-msg exit
			fi
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		if command -v betterlockscreen >/dev/null 2>&1; then
			betterlockscreen -l
		elif command -v hyprlock >/dev/null 2>&1; then
			hyprlock
		elif command -v swaylock >/dev/null 2>&1; then
			swaylock
		elif command -v i3lock >/dev/null 2>&1; then
			i3lock
		fi
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
