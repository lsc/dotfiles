#!/usr/bin/env fish
function tssh --description "SSH to a teleport configured host"
    tsh ssh (fzf < $teleport_host_list)
end
