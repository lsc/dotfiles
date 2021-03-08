#!/usr/bin/env fish
# Run Terraform/Terragrunt interactively throug Docker 
# in a Linux arm64 container
function tid --argument-names tf_dir
  test -z $tf_dir && set tf_dir (pwd)

  docker run --rm -it --name terraform\
    -v {$tf_dir}:/tmp/ -w /tmp\
    -e AWS_VAULT\
    -e AWS_ACCESS_KEY_ID\
    -e AWS_SECRET_ACCESS_KEY\
    -e AWS_SESSION_TOKEN\
    -e AWS_SECURITY_TOKEN\
    -e AWS_SESSION_EXPIRATION\
    -e GITHUB_TOKEN\
    -e DD_API_KEY\
    -e DD_APP_KEY\
    docker-registry.tools.qapital.cloud/qapital/terraform-terragrunt-arm64-linux:v0.2 bash
end


