#!/usr/bin/env bash

polybar --reload --quiet top -c ~/.config/polybar/config.ini &
polybar --reload --quiet bottom -c ~/.config/polybar/config.ini &
polybar --reload --quiet bottom-secondary -c ~/.config/polybar/config.ini &
polybar --reload --quiet bottom-tertiary -c ~/.config/polybar/config.ini &
