#!/usr/bin/env fish
#
function is_installed -a name
    if ! command -v $name &>/dev/null
        echo "This script requires $name but it is not installed"
        return 1
    end
end

set --export EDITOR nvim
set --export USE_GKE_GCLOUD_AUTH_PLUGIN True
set --unexport fish_greeting

set scratch_file ~/.scratch
set teleport_host_list ~/.teleport_hosts

set os (uname)
set shell (basename $SHELL)

if status is-interactive && command -v mise &>/dev/null
    mise activate fish | source
else
    mise activate fish --shims | source
end

if command -v zoxide &>/dev/null
    zoxide init fish | source
end

if command -v jj &>/dev/null
    jj util completion fish | source
end

if status is-interactive && command -v atuin &>/dev/null
    atuin init fish | source
end

if command -v ic &>/dev/null
    bass source (command -v ic)
end

if command -v starship &>/dev/null
    starship init fish | source
end

# Google Cloud SDK
if command -v gcloud &>/dev/null
    switch $os
        case Darwin
            source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.$shell.inc"
        case '*'
            echo "Don't know about $os"
    end
end

function kx --wraps switcher
    kubeswitch $argv
end

alias av aws-vault
alias b brew
alias cat bat
alias e encore
alias g git
alias j just
alias k kubectl
alias ks kubens
alias kx switcher
alias ls 'eza -l --icons --group-directories-first --header --octal-permissions --git'
alias otf tofu
alias spw 'pwgen -anys 32 -1'
alias tf terraform
alias tg terragrunt
alias tm terramate
alias v nvim
