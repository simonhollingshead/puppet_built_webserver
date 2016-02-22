# puppet_built_webserver
The website where I commit all the puppet files that provision me a web server.

# Commands to use to provision
```shell
sudo -i

# First, add the puppet repository for this linux distribution.
pushd /tmp; wget -O puppet.deb https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb; dpkg -i puppet.deb; rm puppet.deb; popd

# Install the dependencies - puppet, and git (where the configs are).
apt-get update; apt-get --yes --force-yes install puppet-agent git;

# Check out git, install the one dependency that puppet can't manage, and decrypt the private key.
# The puppet_module module doesn't seem to be able to install apt, so do so separately.
git clone https://github.com/simonhollingshead/puppet_built_webserver.git /etc/git_puppet; /opt/puppetlabs/puppet/bin/puppet module install dowlingw/puppet_module; /opt/puppetlabs/puppet/bin/puppet module install puppetlabs/apt; gpg /etc/git_puppet/keys/private_*.gpg;

cd /etc/git_puppet

# Decrypt any commercial files that I cannot place on github unencrypted.
for f in modules/cv/files/helveticaneue/*; do gpg --passphrase-fd 0 ./"$f" <keys/private_key.pkcs7.pem ; done

# Apply first, on its own, so we get the encrypted hiera data packages as required.
/opt/puppetlabs/puppet/bin/puppet apply --modulepath /etc/git_puppet/modules:/etc/puppetlabs/code/environments/production/modules -e 'include first'

# Run the entire set of manifests.
/opt/puppetlabs/puppet/bin/puppet apply --modulepath /etc/git_puppet/modules:/etc/puppetlabs/code/environments/production/modules --hiera_config /etc/git_puppet/hiera.yaml /etc/git_puppet/init.pp
```

# Commands to generate a hiera private key
```shell
eyaml createkeys
gpg -c --s2k-cipher-algo AES256 --s2k-digest-algo SHA512 --s2k-count 65011712 .keys/private_key.pkcs7.pem
```

# Commands to encrypt sensitive files
```shell
gpg -c --passphrase-fd 0 --yes --symmetric --cipher-algo AES256 --digest-algo SHA512 FILE_IN_QUESTION < /etc/git_puppet/keys/private_key.pkcs7.pem 
```
