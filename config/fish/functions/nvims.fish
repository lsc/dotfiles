#!/usr/bin/env fish
function nvim-chad
    env NVIM_APPNAME=nvim-chad nvim
end

function nvim-lazy
    env NVIM_APPNAME=nvim-lazy nvim
end

function nvim-astro
    env NVIM_APPNAME=nvim-astro nvim
end

function nvims
    set items nvim-lazy nvim-chad nvim-astro
    set config (printf "%s\n" $items | fzf --prompt=" Neovim Config = " --height=~50% --layout=reverse --border --exit-0)
    if [ -z $config ]
        echo "Nothing selected"
        return 0
    else if [ $config = default ]
        set config ""
    end
    env NVIM_APPNAME=$config nvim $argv
end

bind \ca nvims
