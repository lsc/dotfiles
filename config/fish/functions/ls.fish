#!/usr/bin/env fish
function ls
    if command -v eza &>/dev/null
        eza -l --icons --group-directories-first --header --octal-permissions --git $argv
    else
        ls -lg
    end
end
