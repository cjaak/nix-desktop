#!/usr/bin/env bash
MONITOR="$1"
TAG="$2"

awesome-client "
for s in screen do
    for name, _ in pairs(s.outputs) do
        if name == '${MONITOR}' then
            if s.tags[${TAG}] then s.tags[${TAG}]:view_only() end
            return
        end
    end
end
"