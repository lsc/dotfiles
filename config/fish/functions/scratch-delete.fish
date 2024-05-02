#!/usr/bin/env fish
function scratch-delete --description 'Delete a note from scratch'
    sed -i "/$argv/d" $scratch_file
end

abbr --add scd scratch-delete
