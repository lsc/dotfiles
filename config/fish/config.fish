#!/usr/bin/env fish

set -x PATH /opt/homebrew/opt/make/libexec/gnubin /opt/homebrew/bin ~/go/bin ~/.cargo/bin ~/bin $PATH
set -u EDITOR nvim
set -x TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set -U fish_greeting
test -d $TERRAGRUNT_DOWNLOAD || mkdir -p $TERRAGRUNT_DOWNLOAD
starship init fish | source
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
fish_add_path /opt/homebrew/opt/openjdk@11/bin
