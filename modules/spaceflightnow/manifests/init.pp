class spaceflightnow {
	file { "/opt/spaceflightnow.py":
		mode => "0555",
		source => "puppet:///modules/spaceflightnow/sfn.py",
		require => [Package["python3-icalendar"],Package["python3-bs4"]]
	}
	
	cron { "spaceflightnow":
		ensure => present,
		command => "/opt/spaceflightnow.py",
		minute => 0
	}
}
