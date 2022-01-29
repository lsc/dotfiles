#!/usr/bin/env fish

set --export EDITOR nvim
set --export TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
# We build our Kotlin projects on Java 11 at M
set --export JAVA_HOME /opt/homebrew/opt/openjdk@11/
set --unexport fish_greeting

set add_paths "~/go/bin ~/.cargo/bin ~/bin"

if command -v brew &> /dev/null
    set brew_prefix (brew --prefix)
    fish_add_path "$brew_prefix/opt/openjdk@11/bin" "$brew_prefix/opt/make/libexec/gnubin" "$brew_prefix/bin" "$brew_prefix/sbin"
    set --export HOMEBREW_NO_ENV_HINTS 1
end

for path in $add_paths
    test -d $path && fish_add_path $path
end

source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
source ~/.github-token
source /opt/homebrew/opt/asdf/libexec/asdf.fish

set -x SSH_AUTH_SOCK /Users/lowe.schmidt/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

command -v starship &> /dev/null && starship init fish | source

