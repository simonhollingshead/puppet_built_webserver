define monit::add_monitor($source) {
	file { "/etc/monit/conf.d/$title":
		ensure => file,
		source => $source,
		require => Package["monit"],
		notify => Service["monit"],
		owner => root,
		group => root,
		mode => "0644"
	}
	
	file { "/etc/monit/conf-enabled/$title":
		ensure => link,
		target => "/etc/monit/conf.d/$title",
		require => File["/etc/monit/conf.d/$title"],
		notify => Service["monit"]
	}
}
