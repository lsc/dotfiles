#!/usr/bin/env fish
set --export EDITOR nvim
set --export USE_GKE_GCLOUD_AUTH_PLUGIN True
set --unexport fish_greeting
set --export STARSHIP_DISTRO ""

set os (uname)
set shell (basename $SHELL)

if command -v asdf &>/dev/null
    switch $os
        case Darwin
            source /opt/homebrew/opt/asdf/libexec/asdf.$shell
        case Linux
            source ~/.asdf/libexec/asdf.$shell
        case '*'
            true
    end
end

if status is-interactive && command -v atuin &>/dev/null
    atuin init $shell | source
end

# Google Cloud SDK
if command -v gcloud &>/dev/null
    switch $os
        case Darwin
            source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.$shell.inc"
        case '*'
            true
    end
end

bass source ~/.local/share/nvim/lazy/vmux/plugin/setup_vmux.sh
command -v starship &>/dev/null && starship init fish | source
