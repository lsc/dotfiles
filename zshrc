export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh export LANG=en_US.UTF-8

source <(awless completion zsh)

test -r ~/.github-token && source ~/.github-token
test -x $(command -v keychain) && eval "$(keychain --quiet --eval --ignore-missing id_rsa id_ed25519)"

export DEFAULT_USER=$(whoami)
export PATH="$HOME/bin:$HOME/go/bin:/usr/local/opt/go/libexec/bin:$HOME/context/tex/texmf-osx-64/bin:$PATH"
export CDPATH="$HOME/Projects:$HOME/go/src:$HOME/Projects/terraform/providers"

test -x $(command -v nvim) && alias vim=nvim
alias tf=terraform
alias tg=terragrunt
alias m=minikube
alias dm=docker-machine
alias dco=docker-compose
test -x $(command -v hub) && alias git=hub

eval "$(pyenv init -)"
eval "$(rbenv init -)"

function cluster_config() {
	environment="${1:-}"
	role="${2:-"developers"}"
	github_token="${3:-$GITHUB_TOKEN}"
	domain_name="${4:-"qapital.cloud"}"
	port="${5:-"443"}"

	case $environment in
		staging|production)
			export VAULT_ADDR=https://vault.${environment}.${domain_name}:${port}
			export NOMAD_ADDR=https://nomad.${environment}.${domain_name}:${port}
			export CONSUL_HTTP_ADDR=https://consul.${environment}.${domain_name}:${port}
		;;
		*)
			echo "Environment should be one of staging or production"
			echo "$0 <environment> [role ($role)] [github_token (\$GITHUB_TOKEN)] [domain_name ($domain_name)] [port ($port)]"
			return 1
		;;
	esac

	vault_token=$(vault login -token-only -method=github token=${github_token})
	nomad_token=$(VAULT_TOKEN=${vault_token} vault read -field=secret_id nomad/creds/${role})
	consul_token=$(VAULT_TOKEN=${vault_token} vault read -field=token consul/creds/${role})

	export VAULT_TOKEN="$vault_token"
	export NOMAD_TOKEN="$nomad_token"
	export CONSUL_HTTP_TOKEN="$consul_token"
}

install_spacevim(){
	curl -sLf https://spacevim.org/install.sh | bash
}

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

complete -o nospace -C /usr/local/bin/nomad nomad
complete -o nospace -C /usr/local/bin/consul consul

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/lsc/.zshrc'

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
GTAGSLABEL=pygments
