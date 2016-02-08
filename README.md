# puppet_built_webserver
The website where I commit all the puppet files that provision me a web server.

# Commands to use to provision
```shell
sudo -i

REPOFILE=https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb

cd /tmp
wget -O puppet.deb $REPOFILE
dpkg -i puppet.deb
rm puppet.deb
apt-get update
apt-get --yes --force-yes install puppet-agent git
git clone https://github.com/simonhollingshead/puppet_built_webserver.git /etc/git_puppet
/opt/puppetlabs/puppet/bin/gem install hiera-eyaml
gpg /etc/git_puppet/keys/private_*.gpg

/opt/puppetlabs/puppet/bin/puppet apply --modulepath $WHERE/modules --hiera_config /etc/git_puppet/hiera.yaml /etc/git_puppet/init.pp
```

# Commands to generate a hiera private key
```shell
eyaml createkeys
gpg -c --s2k-cipher-algo AES256 --s2k-digest-algo SHA512 --s2k-count 65011712 .keys/private_key.pkcs7.pem
```