#!/usr/bin/env fish
function clear_aws_variables
  set vars AWS_ACCESS_KEY AWS_SECURITY_TOKEN AWS_SESSION_TOKEN AWS_SECRET_ACCESS_KEY AWS_VAULT AWS_SESSION_EXPIRATION AWS_ACCESS_KEY_ID
  for v in $vars
    set --erase $v
  end

end
