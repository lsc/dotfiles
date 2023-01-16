#!/usr/bin/env fish
set --export EDITOR nvim
set --export USE_GKE_GCLOUD_AUTH_PLUGIN True

set --unexport fish_greeting

set asdf (command -v asdf)
source /opt/homebrew/opt/asdf/libexec/asdf.fish

if status is-interactive
  atuin init fish | source
end

# Google Cloud SDK
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
set lfile "/etc/*-release"
set mfile "/System/Library/CoreServices/SystemVersion.plist"
set --export STARSHIP_DISTRO ""
command -v starship &> /dev/null && starship init fish | source
