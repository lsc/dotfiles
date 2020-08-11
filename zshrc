export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh export LANG=en_US.UTF-8

source <(awless completion zsh)

test -r ~/.github-token && source ~/.github-token
test -r ~/.dir_colors && eval $(gdircolors ~/.dir_colors)
test -x $(command -v keychain) && eval "$(keychain --quiet --eval --ignore-missing id_rsa id_ed25519)"

export DEFAULT_USER=$(whoami)
export PATH="$HOME/bin:$HOME/go/bin:/usr/local/opt/go/libexec/bin:$HOME/context/tex/texmf-osx-64/bin:$PATH"
export LC_ALL=en_GB.UTF-8
export GOPATH="${HOME}/go"
export TERRAGRUNT_DOWNLOAD="${HOME}/.terragrunt-cache"

[[ -d $TERRAGRUNT_DOWNLOAD ]] || mkdir -p $TERRAGRUNT_DOWNLOAD

test -x $(command -v nvim) && alias vim=nvim
alias tf=terraform
alias tg=terragrunt
alias m=minikube
alias d=docker
alias dm=docker-machine
alias dco=docker-compose
test -x $(command -v hub) && alias git=hub

function is_installed {
  local readonly name="$1"

  if [[ ! $(command -v "${name}") ]]; then
    echo "The binary '$name' is required by this script but is not installed or in the system's PATH."
    return 1
  fi
}

function cluster_config() {
  environment="${1:-}"
  role="${2:-"developers"}"
  github_token="${3:-$GITHUB_TOKEN}"
  domain_name="${4:-"qapital.cloud"}"
  port="${5:-"443"}"

  is_installed "vault"
  is_installed "consul"
  is_installed "nomad"

  case $environment in
    staging|stg|production)
      export VAULT_ADDR=https://vault.${environment}.${domain_name}:${port}
      export NOMAD_ADDR=https://nomad.${environment}.${domain_name}:${port}
      export CONSUL_HTTP_ADDR=https://consul.${environment}.${domain_name}:${port}
      echo "VAULT, NOMAD and CONSUL ADDR set"
      ;;
    *)
      echo "Environment should be one of staging or production"
      echo "$0 <environment> [role ($role)] [github_token (\$GITHUB_TOKEN)] [domain_name ($domain_name] [port ($port)]"
      return 1
      ;;
  esac

  vault_token=$(vault login -token-only -method=github token=${github_token})
  nomad_token=$(VAULT_TOKEN=${vault_token} vault read -field=secret_id nomad/creds/${role})
  #consul_token=$(VAULT_TOKEN=${vault_token} vault read -field=token consul/creds/${role}) # The environments does not support this yet, permission is denied even with vault root token..

  if [[ -n $vault_token ]]; then
    export VAULT_TOKEN="$vault_token"
    echo "VAULT_TOKEN set"
  else
    echo "VAULT_TOKEN NOT set (Something went wrong...)"
  fi
  if [[ -n $nomad_token ]]; then
    export NOMAD_TOKEN="$nomad_token"
    echo "NOMAD_TOKEN set"
  else
    echo "NOMAD_TOKEN NOT set (Something went wrong...)"
  fi

  #export CONSUL_HTTP_TOKEN="$consul_token"
  echo "CONSUL_HTTP_TOKEN NOT set (Not supported yet)"
}

install_spacevim(){
	curl -sLf https://spacevim.org/install.sh | bash
}

clear_aws_variables(){
  local vars=( AWS_ACCESS_KEY AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN AWS_SESSION_TOKEN )
  for v in $vars; do
    unset $v
  done
}

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

complete -o nospace -C /usr/local/bin/nomad nomad
complete -o nospace -C /usr/local/bin/consul consul

dm start &> /dev/null
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/lsc/.zshrc'
GTAGSLABEL=pygments
eval "$(pyenv init -)"
eval "$(rbenv init -)"
eval "$(dm env)"
eval "$(starship init zsh)"
