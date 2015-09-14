ZSH=$HOME/.oh-my-zsh

ZSH_THEME="gallifrey"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

plugins=(git rbenv ruby gem bundler osx)

source $ZSH/oh-my-zsh.sh
alias c=clear
alias vim=nvim

# Tmux plugin manager
tpm_install () {
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

# Customize to your needs...
export PATH=/usr/local/bin:$HOME/.rbenv/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
export EDITOR=$(which nvim)
export RBENV_ROOT=~/.rbenv
export GOPATH=~/go
eval "$(rbenv init -)"
eval "$(plenv init -)"
eval "$(pyenv init -)"
