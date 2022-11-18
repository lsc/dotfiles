#!/usr/bin/env fish
function ls
	exa --icons --group-directories-first --header --octal-permissions $argv
end
