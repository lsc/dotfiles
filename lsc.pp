node default {
  class { lsc: }
}

class lsc {

  Package <| provider == tap |> -> Package <| provider == homebrew |>
  Package <| provider == tap |> -> Package <| provider == brew |>
  Package <| provider == tap |> -> Package <| provider == brewcask |>

  $cask_pkg_list = [ '1password', 'slack', 'caffeine', 'google-drive', 'mpv', 'alfred',
                      'iterm2-beta', 'karabiner-elements', 'google-chrome', 'spotify' ]

  $pkg_list = [ 'awscli', 'consul', 'ctags', 'docker', 'docker-machine', 'docker-machine-driver-xhyve',
                'git', 'hugo', 'neovim', 'nomad', 'mutt', 'packer', 'rbenv', 'rcm', 'terraform', 'unrar', 'vault' ]


  package { [ "thoughtbot/formulae", "neovim/neovim" ]:
    ensure   => present,
    provider => tap,
  }

  package { $cask_pkg_list:
    ensure   => present,
    provider => brewcask,
  }

  package { $pkg_list:
    ensure   => present,
    provider => brew,
  }

  exec { 'osx_defaults':
    command => '/bin/sh ./osx',
  }

}
