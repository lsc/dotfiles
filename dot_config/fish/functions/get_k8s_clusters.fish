#!/usr/bin/env fish
#
function get_k8s_clusters --argument-names env
    is_installed curl || exit 1
    is_installed kubectl || exit 1

    set --local out $HOME/.kube/config
    set --local base_url "https://k8sfacts{{ENV}}.imperva-services.net/kubeconfig?role=full-admin&cluster_role_binding=true&user=lowe.schmidt"

    if string match $env prd
        set endpoint (string replace {{ENV}} "" $base_url)
    else if string match $env stg
        set endpoint (string replace {{ENV}} ".$env" $base_url)
    end

    curl -sS $endpoint -o $out &>/dev/null
    chmod 600 $out
end
