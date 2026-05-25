#!/usr/bin/env bash
MONITOR="${1:-DP-2}"
SWITCH="$HOME/.config/polybar/scripts/switch-workspace.sh"

get_monitor_x() {
    xrandr --query | awk "/^${MONITOR} connected/ {
        match(\$0, /[0-9]+x[0-9]+\+([0-9]+)\+[0-9]+/, a); print a[1]
    }"
}

print_workspaces() {
    local monitor_x current output="" tag_idx=0
    monitor_x=$(get_monitor_x)
    [ -z "$monitor_x" ] && return

    current=$(xprop -root _NET_CURRENT_DESKTOP 2>/dev/null | grep -oP '\d+$')

    local -a vx_list names
    mapfile -t vx_list < <(xprop -root _NET_DESKTOP_VIEWPORT 2>/dev/null | grep -oP '\d+' | awk 'NR%2==1')
    mapfile -t names   < <(xprop -root _NET_DESKTOP_NAMES    2>/dev/null | grep -oP '"[^"]*"' | tr -d '"')

    for desktop in "${!vx_list[@]}"; do
        [ "${vx_list[$desktop]}" != "$monitor_x" ] && continue
        ((tag_idx++))
        local name="${names[$desktop]:-$tag_idx}"

        if [ "$desktop" = "$current" ]; then
            output+="%{A1:${SWITCH} ${MONITOR} ${tag_idx}:}%{T6}%{F#FAFAFA}%{+u} ${name} %{-u}%{F-}%{T-}%{A}"
        else
            output+="%{A1:${SWITCH} ${MONITOR} ${tag_idx}:}%{T6}%{F#AAAAAA} ${name} %{F-}%{T-}%{A}"
        fi
    done

    echo "$output"
}

print_workspaces
xprop -root -spy _NET_CURRENT_DESKTOP 2>/dev/null | while read -r _; do
    print_workspaces
done