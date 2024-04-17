#!/usr/bin/env fish
function scratch-edit --description 'Edit scratch file'
    $EDITOR ~/.scratch
end

alias sce scratch-edit
