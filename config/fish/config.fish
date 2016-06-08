# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/lsc/.local/share/omf"
set -gx GOPATH ~/go

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/lsc/.config/omf"

alias vim nvim
alias g git

# Load oh-my-fish configuration.
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (rbenv init -|psub)
source $OMF_PATH/init.fish
