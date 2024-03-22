#!/usr/bin/env fish
function ls
    eza --icons --group-directories-first --header --octal-permissions $argv
end
