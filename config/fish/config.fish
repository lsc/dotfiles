#!/usr/bin/env fish

set --export EDITOR nvim
set --export TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set --export JAVA_HOME (dirname (dirname (asdf which java)))/
set --unexport fish_greeting

source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
source ~/.github-token
source /opt/homebrew/opt/asdf/libexec/asdf.fish

set -x SSH_AUTH_SOCK /Users/lowe.schmidt/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
command -v starship &> /dev/null && starship init fish | source

