#!/usr/bin/env bash

pkill polybar

(
    ~/.scripts/screenlayout/default.sh
    feh --bg-fill ~/.wallpapers/landscape0.png
    picom -b
    ~/.config/polybar/launch.sh
) &

dunstctl set-paused true