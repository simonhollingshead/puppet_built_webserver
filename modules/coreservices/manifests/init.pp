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
}
