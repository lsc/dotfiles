#!/usr/bin/env bash
set -o errexit
set -o nounset

argc=$#

if [[ ${argc} != 2 ]]; then
	usage
fi
while getopts ":u:p:" opt; do
	case ${opt} in
		u)
			user=${OPTARG}
			;;
		p)
			password=${OPTARG}
			;;
		\?)
			usage
			;;
		*)
		usage
			;;
	esac
done


shift $((OPTIN-1))



usage() {
	echo "Usage: $0 -u<Apple ID> -p<Password>"
}

app_store_apps=(
	"497799835"  # Xcode
	"1059655371" # Newton
	"410628904"  # Wunderlist
	"443987910"  # 1Password
)

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install mas

mas signin $user $password

for i in "${app_store_apps[$@]}"; do
	mas install $i
done

brew install rbenv
rbenv install 2.4.1
rbenv global 2.4.1

gem install puppet --no-ri --no-rdoc
puppet module install thekevjames-homebrew --version 1.6.0
puppet apply lsc.pp

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
