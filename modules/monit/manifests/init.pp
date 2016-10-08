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
	
	User <| title == simon |> {
		groups +> "monit",
		require => [Package["monit"],Group["monit"]]
	}
	
	file { "/etc/monit/monitrc":
		ensure => file,
		mode => "0600",
		owner => root,
		group => root,
		require => [Package["monit"],Group["monit"]],
		notify => Service["monit"],
		source => "puppet:///modules/monit/monitrc"
	}
	
	firewall { "281 allow access to monit":
		proto => "tcp",
		dport => "2812",
		action => "accept",
		require => Package["monit"]
	}
}
