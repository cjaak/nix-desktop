#!/usr/bin/env bash
MONITOR="${1:-DP-2}"
SWITCH="$HOME/.config/polybar/scripts/switch-workspace.sh"

ICON_ACTIVE=$'\xef\x84\x91'    # U+F111 filled circle
ICON_OCCUPIED=$'\xef\x86\x92'  # U+F192 dotted circle
ICON_EMPTY=$'\xef\x84\x8c'     # U+F10C empty circle

get_tag_states() {
    awesome-client "
local result = {}
for s in screen do
    for name, _ in pairs(s.outputs) do
        if name == '${MONITOR}' then
            for i, t in ipairs(s.tags) do
                local state = t.selected and 'active'
                           or (#t:clients() > 0 and 'occupied' or 'empty')
                table.insert(result, i .. ':' .. state)
            end
        end
    end
end
return table.concat(result, ',')
" 2>/dev/null | grep -oP '\d+:\w+'
}

print_workspaces() {
    local output=""
    while IFS=':' read -r tag state; do
        local icon
        case "$state" in
            active)   icon="$ICON_ACTIVE" ;;
            occupied) icon="$ICON_OCCUPIED" ;;
            *)        icon="$ICON_EMPTY" ;;
        esac
        output+="%{A1:${SWITCH} ${MONITOR} ${tag}:}%{T6}%{F#FAFAFA} ${icon} %{F-}%{T-}%{A}"
        [[ "$tag" == "5" ]] && output+="%{T6}  %{T-}"
    done < <(get_tag_states)
    echo "$output"
}

print_workspaces

xprop -root -spy _NET_CURRENT_DESKTOP _NET_CLIENT_LIST 2>/dev/null | while read -r _; do
    print_workspaces
done