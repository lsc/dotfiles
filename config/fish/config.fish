#!/usr/bin/env fish

set --export EDITOR nvim
set --export TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set --unexport fish_greeting

command -v gcloud &>/dev/null && source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc

set asdf (command -v asdf)

if [ $asdf = "$HOME/.asdf/bin/asdf" ]
  source $HOME/.asdf/asdf.fish
else if [ $asdf = "/opt/homebrew/opt/asdf/libexec/bin/asdf" ]
  source /opt/homebrew/opt/asdf/libexec/asdf.fish
end

set --export JAVA_HOME (dirname (dirname (asdf which java)))/
set -x SSH_AUTH_SOCK /Users/lowe.schmidt/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
command -v starship &> /dev/null && starship init fish | source

