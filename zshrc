export ZSH=/Users/$(whoami)/.oh-my-zsh

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
	nomad
	osx
	python
	pyenv
	ruby
	rbenv
	terraform
	tmux
	vagrant
	vault
	vi-mode
	vim
	vim-interaction
	zsh_reload
)
source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8

test -r ~/.github-token && source ~/.github-token
test -x $(which docker-machine) && eval "$(docker-machine env &> /dev/null)"
test -x $(which keychain) && eval "$(keychain --quiet --eval --ignore-missing id_rsa id_ed25519)"

export DEFAULT_USER=$(whoami)
export PATH="$PATH:~/bin:/usr/local/opt/go/libexec/bin"
export CDPATH="$HOME/Projects:$HOME/go/src"

alias vim=nvim
alias tf=terraform
alias tg=terragrunt
alias m=minikube
alias dm=docker-machine
alias dco=docker-compose
alias tma='tmux attach -d -t'
alias git-tmux='tmux new -s $(basename $(pwd))'
alias tmux="TERM=screen-256color-bce tmux"

source <(awless completion zsh)
eval "$(go env -)"
eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(dm env)"
source "${HOME}/.zgen/zgen.zsh"
zgen load miekg/lean

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/nomad nomad
export NVM_DIR=/Users/lsc/.nvm
. /usr/local/opt/nvm/nvm.sh

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/lsc/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/lsc/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/lsc/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/lsc/.nvm/versions/node/v8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh