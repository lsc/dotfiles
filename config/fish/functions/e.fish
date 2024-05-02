#!/usr/bin/env fish

function e
    is_installed encore
    encore $argv
end
