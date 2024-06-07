#!/usr/bin/env fish
function ls
    eza -l --icons --group-directories-first --header --octal-permissions --git $argv
end
