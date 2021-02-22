# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}


# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=10'

# ------------------
# Initialize modules
# ------------------

if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# }}} End configuration added by Zim install

export LANG=en_US.UTF-8

source <(awless completion zsh)

test -r ~/.github-token && source ~/.github-token
test -r ~/.dir_colors && eval $(gdircolors ~/.dir_colors)
test -x $(command -v keychain) && eval "$(keychain --quiet --eval --ignore-missing id_rsa id_ed25519)"

export DEFAULT_USER=$(whoami)
export PATH="$HOME/bin:$HOME/go/bin:/usr/local/opt/go/libexec/bin:$PATH"
export LC_ALL=en_GB.UTF-8
export GOPATH="${HOME}/go"
export TERRAGRUNT_DOWNLOAD="${HOME}/.terragrunt-cache"
export EDITOR=$(command -v nvim)

[[ -d $TERRAGRUNT_DOWNLOAD ]] || mkdir -p $TERRAGRUNT_DOWNLOAD

test -x $(command -v nvim) && alias vim=nvim
alias tf=terraform
alias tg=terragrunt
alias m=minikube
alias d=docker
alias dm=docker-machine
alias dco=docker-compose
alias g=git
alias ls='gls --color=auto'
alias ll='ls -al'
alias yaegi='rlwarap yaegi'
alias av="aws-vault"
alias ave="aws-vault exec"

function is_installed {
  local readonly name="$1"

  if [[ ! $(command -v "${name}") ]]; then
    echo "The binary '$name' is required by this script but is not installed or in the system's PATH."
    return 1
  fi
}

if type brew &> /dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit 
  compinit
fi

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

  if [[ -n $vault_token ]]; then
    export VAULT_TOKEN="$vault_token"
  else
    echo "VAULT_TOKEN NOT set (Something went wrong...)"
  fi
  if [[ -n $nomad_token ]]; then
    export NOMAD_TOKEN="$nomad_token"
  else
    echo "NOMAD_TOKEN NOT set (Something went wrong...)"
  fi
  if [[ -n $consul_token ]]; then
    export CONSUL_HTTP_TOKEN="$consul_token"
    else
      echo "CONSUL_TOKEN NOT set (something went wrong...)"
  fi

}

install_spacevim(){
	curl -sLf https://spacevim.org/install.sh | bash
}

clear_aws_variables(){
  local vars=( AWS_ACCESS_KEY AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN AWS_SESSION_TOKEN AWS_VAULT)
  for v in $vars; do
    unset $v
  done
}

autoload -U +X bashcompinit && bashcompinit

complete -o nospace -C /usr/local/bin/nomad nomad
complete -o nospace -C /usr/local/bin/consul consul

dm start &> /dev/null
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/lsc/.zshrc'
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
GTAGSLABEL=pygments
eval "$(dm env &> /dev/null)"
eval "$(aws-vault --completion-script-zsh)"
eval "$(starship init zsh)"

. /usr/local/opt/asdf/asdf.sh
