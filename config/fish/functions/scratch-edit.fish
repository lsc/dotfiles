#!/usr/bin/env fish
function scratch-edit --description "Edit scratch file with $EDITOR"
    $EDITOR $scratch_file
end

abbr --add sce scratch-edit
