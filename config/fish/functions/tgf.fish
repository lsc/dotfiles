#!/usr/bin/env fish
function tgf
  is_installed terragrunt 
  terragrunt hclfmt $argv
end
