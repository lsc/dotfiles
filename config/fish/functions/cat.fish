#!/usr/bin/env fish
function cat
    set is_installed (command -v bat)
    if is_installed
        bat $argv
    else
        cat $argv
    end
end
