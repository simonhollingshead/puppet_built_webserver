class utils {
	package { ["vim","lynx","elinks","git","gitk","mtr","nmon","htop","nethogs","patch","rsync","weechat","php-cli","iotop","screen"]:
		ensure => present
	}
	
    class { 'composer':
        command_name => 'composer',
        target_dir => '/usr/local/bin',
        auto_update => true,
        require => Package["php-cli"]
    }
	
	file { "/usr/bin/start_weechat":
		ensure => file,
		mode => "0755",
		owner => root,
		group => root,
		source => "puppet:///modules/utils/start_weechat",
		require => [Package["weechat"],Package["screen"]]
	}
}
