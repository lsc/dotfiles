#!/usr/bin/env fish
function ta --description "Authenticate to a teleport cluster"
    set env $argv[1]
    switch $env
        case stg
            tsh stg
        case prd
            tsh prd
        case '*'
            echo "Unknown environment $env, aborting"
            return 1
    end
end
