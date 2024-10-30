#!/usr/bin/env dev
set ip 127.1

function dev
    ssh $ip -p 22022 -l lsc
end
