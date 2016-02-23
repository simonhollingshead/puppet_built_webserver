#!/bin/bash

ORANGE='\033[0;33m'
NONE='\033[0m'
FIFTY="**************************************************\n"
DISTRO="trusty"
INSTALL_DST="/etc/git_puppet"

printf "\n"
printf "\n"
printf "${FIFTY}"
printf "* Dropping to root user.\n"
printf "${FIFTY}"

sudo -i

printf "\n"
printf "\n"
printf "${FIFTY}"
printf "* Adding puppet repository."
printf "${FIFTY}"

pushd /tmp
wget -O puppet.deb "https://apt.puppetlabs.com/puppetlabs-release-pc1-${DISTRO}.deb"
dpkg -i puppet.deb
rm puppet.deb
popd

printf "\n"
printf "\n"
printf "${FIFTY}"
printf "* Installing prerequisites."
printf "${FIFTY}"

apt-get update
apt-get --yes --force-yes install puppet-agent git

printf "\n"
printf "\n"
printf "${FIFTY}"
printf "* Cloning GitHub repository."
printf "${FIFTY}"

git clone https://github.com/simonhollingshead/puppet_built_webserver.git "${INSTALL_DST}"
pushd "${INSTALL_DST}"
git remote set-url origin git@github.com:simonhollingshead/puppet_built_webserver.git
popd

printf "\n"
printf "\n"
printf "${FIFTY}"
printf "* Installing manifest prerequisites."
printf "${FIFTY}"
/opt/puppetlabs/puppet/bin/puppet module install dowlingw/puppet_module
/opt/puppetlabs/puppet/bin/puppet module install puppetlabs/apt

printf "\n"
printf "\n"
printf "${FIFTY}"
printf "* Decrypting secured files."
printf "${FIFTY}"

gpg "${INSTALL_DST}/keys/private_*.gpg"
for f in "${INSTALL_DST}/modules/cv/files/helveticaneue/*"; do gpg --passphrase-fd 0 ./"$f" <"${INSTALL_DST}/keys/private_key.pkcs7.pem" ; done

printf "\n"
printf "\n"
printf "${FIFTY}"
printf "* Performing first puppet run."
printf "${FIFTY}"

/opt/puppetlabs/puppet/bin/puppet apply --modulepath "${INSTALL_DST}/modules":/etc/puppetlabs/code/environments/production/modules -e 'include first'

/opt/puppetlabs/puppet/bin/puppet apply --modulepath "${INSTALL_DST}/modules":/etc/puppetlabs/code/environments/production/modules -e 'include second'

/opt/puppetlabs/puppet/bin/puppet apply --modulepath "${INSTALL_DST}/modules":/etc/puppetlabs/code/environments/production/modules --hiera_config /etc/git_puppet/hiera.yaml /etc/git_puppet/init.pp


