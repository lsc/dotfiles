#!/usr/bin/env fish
function scratch-add --description 'Add a note to scratch'
    echo $argv >>$scratch_file
end

alias sca scratch-add
