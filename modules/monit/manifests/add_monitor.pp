define monit::add_monitor($use_template=false, $source="", $content="") {
	if($use_template) {
		file { "/etc/monit/conf.d/$title.conf":
			ensure => file,
			content => $content,
			require => Package["monit"],
			notify => Service["monit"],
			owner => root,
			group => root,
			mode => "0644"
		}
	} else {
		file { "/etc/monit/conf.d/$title.conf":
			ensure => file,
			source => $source,
			require => Package["monit"],
			notify => Service["monit"],
			owner => root,
			group => root,
			mode => "0644"
		}
	}
	
	file { "/etc/monit/conf-enabled/$title.conf":
		ensure => link,
		target => "/etc/monit/conf.d/$title.conf",
		require => File["/etc/monit/conf.d/$title.conf"],
		notify => Service["monit"]
	}
}
