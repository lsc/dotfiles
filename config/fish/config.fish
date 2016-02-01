# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/lsc/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/lsc/.config/omf"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

# My own stuff
set -gx GOPATH "{$HOME}/go"
alias vim "nvim"
