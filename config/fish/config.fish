#!/usr/bin/env fish

set --export EDITOR nvim
set --export TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set --unexport fish_greeting

set -x PATH $HOME/.cargo/bin $HOME/.asdf/shims $HOME/.asdf/bin $PATH

command -v gcloud &>/dev/null && source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc

if command -v asdf == $HOME/.asdf/bin/asdf
  source $HOME/.asdf/asdf.fish
else if command -v &> /dev/null asdf == /opt/homebrew/opt/asdf/libexec/bin/asdf
  source /opt/homebrew/opt/asdf/libexec/asdf.fish
end

set --export JAVA_HOME (dirname (dirname (asdf which java)))/
set -x SSH_AUTH_SOCK /Users/lowe.schmidt/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
command -v starship &> /dev/null && starship init fish | source

