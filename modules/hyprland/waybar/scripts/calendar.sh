#!/usr/bin/env bash
if pgrep -f "class=cal-popup" > /dev/null; then
    pkill -f "class=cal-popup"
else
    wezterm start --class=cal-popup -- bash -c \
        'printf "\033[?25l"; while true; do clear; ncal -3 -b; sleep 60; done'
fi