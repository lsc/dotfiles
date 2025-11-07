#!/usr/bin/env fish
function sk --argument-names layout
    if not command -v hyprctl &>/dev/null
        echo "hyprctl: command not found, exiting"
        exit 1
    end
    hyprctl keyword input:kb_layout $layout
end
