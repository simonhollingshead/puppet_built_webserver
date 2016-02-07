# puppet_built_webserver
The website where I commit all the puppet files that provision me a web server.

# Commands to use to provision
```shell
sudo -i

WHERE=/etc/git_puppet
REPOFILE=https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb

cd /tmp
wget -O puppet.deb $REPOFILE
dpkg -i puppet.deb
rm puppet.deb
apt-get update
apt-get --yes --force-yes install puppet-agent git
git clone https://github.com/simonhollingshead/puppet_built_webserver.git $WHERE
puppet module install puppetlabs-apt

/opt/puppetlabs/puppet/bin/puppet apply --modulepath $WHERE/modules $WHERE/init.pp
```
