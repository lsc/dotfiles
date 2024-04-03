#!/usr/bin/env fish
set --export EDITOR nvim
set --export USE_GKE_GCLOUD_AUTH_PLUGIN True
set --unexport fish_greeting
set --export STARSHIP_DISTRO ""

set os (uname)
set shell (basename $SHELL)

if command -v mise &>/dev/null
    mise activate fish | source
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
