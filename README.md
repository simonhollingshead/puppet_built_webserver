# puppet_built_webserver
The website where I commit all the puppet files that provision me a web server.

# Command to use to provision
```shell
sudo -i
curl -sfL https://raw.githubusercontent.com/simonhollingshead/puppet_built_webserver/master/bootstrap.sh | bash
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
