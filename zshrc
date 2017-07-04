## Path to your oh-my-zsh installation.
export ZSH=/Users/$(whoami)/.oh-my-zsh

ZSH_THEME="agnoster"
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"
plugins=(
	aws
	brew
	colored-man-pages
	common-aliases
	docker
	git
	github
	golang
	gradle
	kubectl
	nomad
	osx
	python
	ruby
	terraform
	tmux
	vault
	vi-mode
	vim
	vim-interaction
	zsh_reload
)
source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8

test -r ~/.github-token && source ~/.github-token
test -r ~/.vsphere-credentials && source ~/.vsphere-credentials
test -x $(which docker-machine) && eval "$(docker-machine env)"
test -x $(which keychain) && eval "$(keychain --quiet --eval id_rsa)"

export DEFAULT_USER=$(whoami)
export GOPATH=${HOME}/go
export PATH="$PATH:${GOPATH}/bin"

alias vim=nvim
alias tf=terraform
alias m=minikube
alias dm=docker-machine
alias tma='tmux attach -d -t'
alias git-tmux='tmux new -s $(basename $(pwd))'
alias tmux="TERM=screen-256color-bce tmux"

# Things I don't currently use...
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# ZSH_CUSTOM=/path/to/new-custom-folder
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/lsc/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/lsc/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/lsc/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/lsc/google-cloud-sdk/completion.zsh.inc'; fi
