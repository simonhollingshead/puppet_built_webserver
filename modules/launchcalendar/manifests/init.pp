class launchcalendar {
	file { "/opt/launchcalendar.py":
		mode => "0555",
		source => "puppet:///modules/launchcalendar/launchcalendar.py",
		require => [Package["python3-icalendar"],Package["python3-bs4"],File["/srv/www/launchcalendar"]]
	}
	
	file { "/var/log/launchcalendar":
		ensure => directory,
		mode => "0644",
		owner => www-data,
		group => www-data
	}
	
	file { "/var/log/launchcalendar/result.log":
		ensure => present,
		replace => no,
		content => "",
		owner => "www-data",
		group => "www-data",
		mode => "0644",
		require => File["/var/log/launchcalendar"]
	}
	
	cron { "launchcalendar":
		ensure => present,
		user => www-data,
		command => "/opt/launchcalendar.py > /var/log/launchcalendar/result.log",
		minute => 0,
		require => [File["/opt/launchcalendar.py"],File["/var/log/launchcalendar"],File["/srv/www/launchcalendar"]]
	}

	nginx::new_subdomain{ "launchcalendar": }
}	
