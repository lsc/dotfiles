#!/usr/bin/env fish
set --export EDITOR nvim
set --unexport fish_greeting

set asdf (command -v asdf)
source /opt/homebrew/opt/asdf/libexec/asdf.fish

command -v starship &> /dev/null && starship init fish | source

if status is-interactive
  atuin init fish | source
end
# Google Cloud SDK
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
