#!/usr/bin/env bash

Main() {
    rofi                                \
        -show window                    \
        -config "$HOME/.config/rofi/config.rasi"
}

Main "$@"