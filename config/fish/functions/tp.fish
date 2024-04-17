#!/usr/bin/env fish
function tp --description "Ping a teleport configured host"
    _generate_teleport_host_list
    ping -c 10 (fzf < $teleport_host_list)
end
