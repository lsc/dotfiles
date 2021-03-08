#!/usr/bin/env fish
function is_installed -a name
  if ! command -v $name 
    echo "This script requires $name but it is not installed"
    return 1
  end
end


