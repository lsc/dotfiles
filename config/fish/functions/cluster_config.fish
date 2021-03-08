#!/usr/bin/env fish
function cluster_config --description "Configure Qapitals HashiStack endpoints and retrieve tokens"  --argument-names environment role github_token
  set -q environment environment[1] or set environment "staging"
  set -q role role[1] or set role "developers"

  set domain_name  "qapital.cloud"
  set port  "443"

  is_installed "vault"
  is_installed "consul"
  is_installed "nomad"

  switch $environment 
      case staging production
        set -g -x VAULT_ADDR "https://vault.$environment.$domain_name:$port"
        set -g -x NOMAD_ADDR "https://nomad.$environment.$domain_name:$port"
        set -g -x CONSUL_HTTP_ADDR "https://consul.$environment.$domain_name:$port"
  case *
      echo "Environment should be one of staging or production"
      echo "$0 <environment> [role ($role)]" 
      return 1
  end

  set vault_token (vault login -token-only -method=github token="$GITHUB_TOKEN")
  set nomad_token (VAULT_TOKEN={$vault_token} vault read -field=secret_id nomad/creds/{$role})
  set consul_token (VAULT_TOKEN={$vault_token} vault read -field=token consul/creds/{$role})

  set -g -x VAULT_TOKEN $vault_token
  set -g -x NOMAD_TOKEN $nomad_token
  set -g -x CONSUL_HTTP_TOKEN $consul_token
end
