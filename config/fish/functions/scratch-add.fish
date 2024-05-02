#!/usr/bin/env fish
function scratch-add --description 'Add a note to scratch'
    echo $argv >>$scratch_file
end

abbr --add sca scratch-add
