class utils {
	package { ["vim","lynx","elinks","git","gitk","mtr","nmon","htop","nethogs","patch","rsync","weechat","php-cli","iotop"]:
		ensure => present
	}
	
    class { 'composer':
        command_name => 'composer',
        target_dir => '/usr/local/bin',
        auto_update => true,
        require => Package["php-cli"]
    }
	
	# TODO: Remove when no longer using Koding.
	package { ["golang-go","golang-go-linux-amd64","golang-src","libgl1-mesa-dri","puppetserver"]:
	    ensure => purged
	}
}
