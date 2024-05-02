#!/usr/bin/env fish
function scratch-find
    is_installed fzf
    fzf <$scratch_file
end

abbr --ad scf scratch-find
