#!/usr/bin/env fish
function tssh --description "SSH to a teleport configured host"
    _generate_teleport_host_list
    tsh ssh (fzf < $teleport_host_list)
end
