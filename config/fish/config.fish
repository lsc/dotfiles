# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/lsc/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/lsc/.config/omf"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

# My own stuff
set -gx GOPATH "$HOME/go"
set -gx ANSIBLE_HOME "$HOME/.ansible"
set -gx PATH /opt/puppetlabs/bin $PATH
set fish_greeting ""
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (plenv init -|psub)
alias vim "nvim"
