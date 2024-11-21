#!/usr/bin/env fish
#
function get_k8s_clusters --argument-names env
    is_installed curl || exit 1
    is_installed kubectl || exit 1

    set --local out $HOME/.kube/k8sfactsconfig-$env.yaml
    set --local user lowe.schmidt
    set --local endpoint "https://k8sfacts-$env.imperva-services.net/kubeconfig?role=full-admin&cluster_role_binding=true&user=$user"

    echo $out
    echo $endpoint
    echo $user

    begin
        curl -sS $endpoint -o $out &>/dev/null
        chmod 600 $out
        test (set --query KUBECONFIG) && set --append KUBECONFIG $out
    end

    set --export KUBECONFIG
end
