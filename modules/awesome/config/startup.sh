#!/usr/bin/env bash

pkill polybar
pkill dunst

xinput set-prop "SteelSeries SteelSeries Aerox 9 Wireless" "libinput Middle Emulation Enabled" 0 2>/dev/null || true

dunst &

(
    ~/.scripts/screenlayout/default.sh
    feh --bg-fill ~/.wallpapers/landscape0.png
    picom -b
    ~/.config/polybar/launch.sh
) &