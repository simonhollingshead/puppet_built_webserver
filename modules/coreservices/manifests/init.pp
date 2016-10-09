class coreservices {
	package { "ssh":
		ensure => installed
	}
		
	class { 'ssh':
		storeconfigs_enabled => false,
		server_options => {
			'PasswordAuthentication' => 'no',
			'PermitRootLogin' => 'no',
			'Port' => [2222],
			'X11Forwarding' => yes
		},
		users_client_options => {
			'simon' => {
				options => {
					'Host github.*' => {
						'User' => 'git',
						'IdentityFile' => '/home/simon/.ssh/github_rsa'
					}
				}
			}
		},
		require => [Package["ssh"],User["simon"]]
	}
	
	firewall { "022 allow access to ssh":
		proto => "tcp",
		dport => "ssh",
		action => "accept",
		require => Class["ssh"]
	}
	
	exec { "/usr/bin/timedatectl set-timezone UTC":
		user => root,
		onlyif => "/usr/bin/timedatectl | grep 'Time zone: UTC'; test $? -eq 1"
	}
	
	monit::add_monitor { "ssh":
		source => "puppet:///modules/coreservices/monit/ssh.conf"
	}

	monit::add_monitor { "disk":
		source => "puppet:///modules/coreservices/monit/disk.conf"
	}
}
