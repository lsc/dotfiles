#!/usr/bin/env fish

if command -v brew &> /dev/null
    set brew_prefix (brew --prefix)
    fish_add_path "$brew_prefix/opt/openjdk@11/bin" "$brew_prefix/opt/make/libexec/gnubin" "$brew_prefix/bin" "$brew_prefix/sbin"
end

test -d ~/go/bin && fish_add_path ~/go/bin
test -d ~/.cargo/bin && fish_add_path ~/.cargo/bin
test -d ~/bin && fish_add_path ~/bin

set gcloud_inc "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
set --export EDITOR nvim
set --export TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set --export JAVA_HOME /opt/homebrew/opt/openjdk@11/
test -d $TERRAGRUNT_DOWNLOAD || mkdir -p $TERRAGRUNT_DOWNLOAD
set --unexport fish_greeting
test -f $gcloud_inc && source $gcloud_inc
test -f ~/.github-token && source ~/.github-token
command -v starship &> /dev/null && starship init fish | source

