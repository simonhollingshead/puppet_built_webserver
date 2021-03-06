class monit {
	package { "monit":
		ensure => installed
	}
	
	service { "monit":
		ensure => running,
		enable => true,
		require => [Package["monit"],Firewall["281 allow access to monit"]]
	}
	
	group { "monit":
		ensure => present
	}
	
	file { "/etc/monit/monitrc":
		ensure => file,
		mode => "0600",
		owner => root,
		group => root,
		require => Package["monit"],
		notify => Service["monit"],
		source => "puppet:///modules/monit/monitrc"
	}
	
	file { "/etc/monit/check_type.sh":
		ensure => file,
		mode => "0655",
		owner => root,
		group => root,
		require => Package["monit"],
		source => "puppet:///modules/monit/check_type.sh"
	}
	
	firewall { "281 allow access to monit":
		proto => "tcp",
		dport => "2812",
		action => "accept",
		require => Package["monit"]
	}
}
