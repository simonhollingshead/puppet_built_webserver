#!/bin/bash

YELLOW=$(tput bold;tput setaf 3)
NONE=$(tput sgr0)
FIFTY="**************************************************"
DISTRO="trusty"
INSTALL_DST="/etc/git_puppet"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

if [ ! -d $INSTALL_DST ]
then
	printf "\n"
	printf "\n"
	printf "%s%s\n" "${YELLOW}" "${FIFTY}"
	printf "* %s\n" "Adding puppet repository."
	printf "%s%s\n" "${FIFTY}" "${NONE}"
	
	pushd /tmp
	wget -O puppet.deb "https://apt.puppetlabs.com/puppetlabs-release-pc1-${DISTRO}.deb"
	dpkg -i puppet.deb
	rm puppet.deb
	popd
	
	printf "\n"
	printf "\n"
	printf "%s%s\n" "${YELLOW}" "${FIFTY}"
	printf "* %s\n" "Installing prerequisite packages."
	printf "%s%s\n" "${FIFTY}" "${NONE}"
	
	apt-get update  < "/dev/null"
	apt-get --yes --force-yes install puppet-agent git < "/dev/null"
	
	printf "\n"
	printf "\n"
	printf "%s%s\n" "${YELLOW}" "${FIFTY}"
	printf "* %s\n" "Cloning GitHub repository."
	printf "%s%s\n" "${FIFTY}" "${NONE}"
	
	git clone https://github.com/simonhollingshead/puppet_built_webserver.git "${INSTALL_DST}"
	pushd "${INSTALL_DST}"
	git remote set-url origin git@github.com:simonhollingshead/puppet_built_webserver.git
	popd
	
	printf "\n"
	printf "\n"
	printf "%s%s\n" "${YELLOW}" "${FIFTY}"
	printf "* %s\n" "Installing prerequisite puppet modules."
	printf "%s%s\n" "${FIFTY}" "${NONE}"
	/opt/puppetlabs/puppet/bin/puppet module install dowlingw/puppet_module
	/opt/puppetlabs/puppet/bin/puppet module install puppetlabs/apt
	
	printf "\n"
	printf "\n"
	printf "%s%s\n" "${YELLOW}" "${FIFTY}"
	printf "* %s\n" "Decrypting private files."
	printf "%s%s\n" "${FIFTY}" "${NONE}"
	
	gpg "${INSTALL_DST}"/keys/private_*.gpg
	for f in "${INSTALL_DST}"/modules/cv/files/helveticaneue/*
	do
		gpg --passphrase-fd 0 "$f" <"${INSTALL_DST}/keys/private_key.pkcs7.pem"
	done
	
	printf "\n"
	printf "\n"
	printf "%s%s\n" "${YELLOW}" "${FIFTY}"
	printf "* %s\n" "Executing first-time puppet modules."
	printf "%s%s\n" "${FIFTY}" "${NONE}"
	
	/opt/puppetlabs/puppet/bin/puppet apply --modulepath "${INSTALL_DST}/modules":/etc/puppetlabs/code/environments/production/modules -e 'include first'
	
	/opt/puppetlabs/puppet/bin/puppet apply --modulepath "${INSTALL_DST}/modules":/etc/puppetlabs/code/environments/production/modules -e 'include second'
fi;


printf "\n"
printf "\n"
printf "%s%s\n" "${YELLOW}" "${FIFTY}"
printf "* %s\n" "Running puppet manifest."
printf "%s%s\n" "${FIFTY}" "${NONE}"

/opt/puppetlabs/puppet/bin/puppet apply --modulepath "${INSTALL_DST}/modules":/etc/puppetlabs/code/environments/production/modules --hiera_config /etc/git_puppet/hiera.yaml /etc/git_puppet/init.pp
