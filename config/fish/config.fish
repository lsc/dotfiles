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

alias b "bundler"
alias buu "brew update; and brew upgrade --all"
alias d "docker"
alias dm "docker-machine"
alias ds "docker-swarm"
alias dco "docker-compose"
alias be "bundler exec"
alias g "git" 
alias gf "git flow"
alias h "heroku"
alias v "vim"
alias vim "nvim"

function create_draft
	set base_dir "~/Projects/lsc.github.io"
	set drafts_dir "$base_dir/_drafts"
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
