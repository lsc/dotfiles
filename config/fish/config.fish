#!/usr/bin/env fish

set --export EDITOR nvim
set --export TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set --export JAVA_HOME (dirname (dirname (asdf which java)))/
set --unexport fish_greeting

command -v gcloud &>/dev/null && source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
command -v asdf &> /dev/null && source /opt/homebrew/opt/asdf/libexec/asdf.fish

set -x SSH_AUTH_SOCK /Users/lowe.schmidt/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
command -v starship &> /dev/null && starship init fish | source

