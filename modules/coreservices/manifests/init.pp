class coreservices {
	package { "ssh":
		ensure => installed
	}
	
	class { 'ssh::server':
		storeconfigs_enabled => false,
		options => {
			'PasswordAuthentication' => 'no',
			'PermitRootLogin' => 'no',
			'Port' => [2222],
			'X11Forwarding' => yes
		},
		require => Package["ssh"]
	}
}
