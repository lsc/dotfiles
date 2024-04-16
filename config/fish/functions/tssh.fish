#!/usr/bin/env fish
function tssh
    tsh ssh (tsh ls --format names | fzf)
end
