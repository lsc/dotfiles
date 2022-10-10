#!/usr/bin/env fish

set --export EDITOR nvim
set --export TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set --unexport fish_greeting

set asdf (command -v asdf)
source /opt/homebrew/opt/asdf/libexec/asdf.fish

command -v starship &> /dev/null && starship init fish | source

if status is-interactive
  atuin init fish | source
end
