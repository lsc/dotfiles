#!/usr/bin/env fish
set --export EDITOR nvim
set --export USE_GKE_GCLOUD_AUTH_PLUGIN True
set --unexport fish_greeting
set --export STARSHIP_DISTRO ""

set os (uname)
set shell (basename $SHELL)

if (command -v asdf)
    switch $os
        case Darwin
            source /opt/homebrew/opt/asdf/libexec/asdf.$shell
        case Linux
            source ~/.asdf/libexec/asdf.$shell
        case '*'
            true
    end
end

if status is-interactive
  atuin init $shell | source
end

# Google Cloud SDK
if (command -v gcloud)
    switch $os
        case Darwin
            source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.$shell.inc"
        case '*'
            true
    end
end
            

command -v starship &> /dev/null && starship init fish | source
