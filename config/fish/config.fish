#!/usr/bin/env fish

set -x PATH /opt/homebrew/bin ~/bin ~/go/bin $PATH
set -u EDITOR nvim
set -x TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set -U fish_greeting
test -d $TERRAGRUNT_DOWNLOAD || mkdir -p $TERRAGRUNT_DOWNLOAD
starship init fish | source
test -r ~/.github-token && source ~/.github-token &> /dev/null
source /opt/homebrew/opt/asdf/asdf.fish
