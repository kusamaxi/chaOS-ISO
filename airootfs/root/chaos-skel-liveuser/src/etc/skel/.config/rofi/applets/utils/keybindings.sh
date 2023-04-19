#!/usr/bin/env bash

awk '/^[a-z]/ && last {print "<small>",$0,"\t",last,"</small>"} {last=""} /^#/{last=$0}' ~/.config/sxhkd/sxhkdrc |
	column -t -s $'\t' |
	rofi -dmenu -i -p "keybindings:" -markup-rows -no-show-icons -width 1000 -lines 15 -yoffset 40 -theme ~/.config/rofi/applets/utils/clipboard.rasi -font "Unbounded Regular 16"
