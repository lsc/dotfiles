#!/usr/bin/env fish

function tsp --description "Select a teleport profile"
    set -l profiles stg prd
    set profile $argv[1]
    set tstatus (tsh status)

    switch $profile
        case stg
            echo "teleport.stg.imperva-services.net" >~/.tsh/current-profile
        case prd
            echo "teleport.imperva-services.net" >~/.tsh/current-profile
        case '*'
            echo "Unknown profile: $profile. Should be one of $profiles"
            return 1
    end

    if test $tstatus -ne 0
        echo "Not currently authenticated to teleport, will autenticate now"
        ta $profile
    end

end
