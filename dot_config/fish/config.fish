#!/usr/bin/env fish

function is_installed -a name
    if ! command -v $name &>/dev/null
        echo "This script requires $name but it is not installed"
        return 1
    end
end

bind \cg __zoxide_zi

set --export EDITOR nvim
set --export USE_GKE_GCLOUD_AUTH_PLUGIN True
set --export TELEPORT_ADD_KEYS_TO_AGENT no
test -d ~/.cache/go-mod/ || mkdir ~/.cache/go-mod/
set --export GOMODCACHE ~/.cache/go-mod/
set --export SSH_AUTH_SOCK $HOME/.bitwarden-ssh-agent.sock
set --unexport fish_greeting

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

if test -f ~/.github-token
    set --export GITHUB_TOKEN (cat ~/.github-token)
end

functions -c fish_prompt _original_fish_prompt 2>/dev/null

function fish_prompt
    if set -q ZMX_SESSION
        echo -n "[$ZMX_SESSION]"
    end
    _original_fish_prompt
end

alias av aws-vault
alias b brew
alias c chezmoi
alias cat bat
alias g git
alias k kubectl
alias ks kubens
alias kx kubectx
alias ls 'eza -l --icons --group-directories-first --header --octal-permissions'
alias m mise
alias otf tofu
alias spw 'pwgen -anys 32 -1'
alias tf terraform
alias tg terragrunt
alias tm terramate
alias v nvim
