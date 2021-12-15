#!/usr/bin/env fish

set --export EDITOR nvim
set --export TERRAGRUNT_DOWNLOAD ~/.terragrunt-cache
set --export JAVA_HOME /opt/homebrew/opt/openjdk@11/
set --unexport fish_greeting

set source_files "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc ~/.github-token /opt/homebrew/opt/asdf/libexec/asdf.fish"
set add_paths "~/go/bin ~/.cargo/bin ~/bin"

if command -v brew &> /dev/null
   set brew_prefix (brew --prefix)
   fish_add_path "$brew_prefix/opt/openjdk@11/bin" "$brew_prefix/opt/make/libexec/gnubin" "$brew_prefix/bin" "$brew_prefix/sbin"
end

for path in $add_paths
	test -d $path && fish_add_path $path
end

for file in $source_files
	test -f $file && source $file
end


command -v starship &> /dev/null && starship init fish | source
