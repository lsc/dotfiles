## Path to your oh-my-zsh installation.
export ZSH=/Users/$(whoami)/.oh-my-zsh

ZSH_THEME="agnoster"
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"
plugins=(git osx rbenv golang ruby vim python pyenv docker)
source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8

if [[ -r ~/.github-token ]]; then
	source ~/.github-token
fi

if [[ -r ~/.vsphere-credentials ]]; then
	source ~/.vsphere-credentials
fi

eval "$(pyenv init -)"
eval "$(rbenv init -)"
eval "$(keychain --eval id_rsa)"
eval "$(docker-machine env)"

export DEFAULT_USER=$(whoami)
export GOPATH=${HOME}/go
export K8S_REGISTRY=$(kubectl get pods --namespace kube-system -l k8s-app=kube-registry -o template --template '{{range .items}}{{.metadata.name}} {{.status.phase}}{{"\n"}}{{end}}' | grep Running | head -1 | cut -f1 -d' ')
export PATH="$PATH:${GOPATH}/bin"
alias vim=nvim
alias tf=terraform
alias tg=terragrunt
alias m=minikube
alias dm=docker-machine

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
