#!/usr/bin/env fish
#
function get_k8s_clusters --argument-names env
    is_installed curl || exit 1
    is_installed kubectl || exit 1

    set --local out $HOME/.kube/k8sfactsconfig-$env.yaml
    set --local user lowe.schmidt
    set --local base_url "https://k8sfacts{{ENV}}.imperva-services.net/kubeconfig?role=full-admin&cluster_role_binding=true&user=$user"

    if string match $env prd
        set endpoint (string replace {{ENV}} "" $base_url)
    else if string match $env stg
        set endpoint (string replace {{ENV}} ".$env" $base_url)
    end

    curl -sS $endpoint -o $out &>/dev/null
    chmod 600 $out

    set --append KUBECONFIG $out
    set --export KUBECONFIG
end
