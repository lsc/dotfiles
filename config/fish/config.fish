#!/usr/bin/env fish

set --export EDITOR nvim
set --export TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set --unexport fish_greeting

set asdf (command -v asdf)
source /opt/homebrew/opt/asdf/libexec/asdf.fish

command -v starship &> /dev/null && starship init fish | source

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
