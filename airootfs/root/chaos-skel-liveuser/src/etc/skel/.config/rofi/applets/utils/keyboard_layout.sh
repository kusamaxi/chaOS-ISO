#!/bin/bash

layouts=("us" "fi") # Add or modify the keyboard layouts here
current_layout=$(setxkbmap -query | awk '/layout:/ {print $2}')

selected_layout=$(printf "%s\n" "${layouts[@]}" | rofi -dmenu -p "Keyboard Layout" -theme ~/.config/rofi/chaos/clipboard.rasi -font ~/.config/rofi/shared/fonts.rasi)

if [ -n "$selected_layout" ]; then
	setxkbmap "$selected_layout"
fi
