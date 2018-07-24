export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh export LANG=en_US.UTF-8

source <(awless completion zsh)

test -r ~/.github-token && source ~/.github-token
test -x $(which keychain) && eval "$(keychain --quiet --eval --ignore-missing id_rsa id_ed25519)"

export DEFAULT_USER=$(whoami)
export PATH="$PATH:$HOME/bin:$HOME/go/bin:/usr/local/opt/go/libexec/bin:$HOME/context/tex/texmf-osx-64/bin"
export CDPATH="$HOME/Projects:$HOME/go/src:$HOME/Projects/terraform/providers"

alias vim=nvim
alias tf=terraform
alias tg=terragrunt
alias m=minikube
alias dm=docker-machine
alias dco=docker-compose
eval "$(pyenv init -)"
eval "$(rbenv init -)"

function cluster_config() {
	environment=${1:-staging}
	domain_name=${2:-qapital.lan}
	port=${3:-443}
	export CONSUL_HTTP_ADDR="https://consul.${environment}.${domain_name}:${port}"
	export NOMAD_ADDR="https://nomad.${environment}.${domain_name}:${port}"
	export VAULT_ADDR="https://vault.${environment}.${domain_name}:${port}"
	test -r ~/."${environment}"_cluster_token && source ~/."${environment}"_cluster_token
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/nomad nomad
