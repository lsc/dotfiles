#!/usr/bin/env fish
function _generate_teleport_host_list
    if test ! -r $teleport_host_list
        tsh ls --format names >$teleport_host_list
    end
end
