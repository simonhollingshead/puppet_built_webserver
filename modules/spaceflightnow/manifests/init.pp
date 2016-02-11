class spaceflightnow {
	file { "/opt/spaceflightnow.py":
		mode => "0555",
		source => "puppet:///modules/spaceflightnow/sfn.py",
		require => [Package["python3-icalendar"],Package["python3-bs4"],File["/srv/www/sfn"]]
	}
	
	cron { "spaceflightnow":
		ensure => present,
		user => www-data,
		command => "/opt/spaceflightnow.py",
		minute => 0,
		require => File["/opt/spaceflightnow.py"]
	}
	
	file { "/srv/www/sfn":
        source => "puppet:///modules/spaceflightnow/web-files",
        recurse => true,
        require => File["/srv/www"],
        owner => www-data,
        group => www-data,
        mode => "0644"
    }
    
    file { "/srv/www/sfn/media":
        ensure => "link",
        target => "/srv/www/none/media",
        require => File["/srv/www/none"]
    }
    
    file { "/etc/nginx/sites-available/spaceflightnow":
        mode   => "0644",
        owner  => root,
        group  => root,
        source => "puppet:///modules/spaceflightnow/spaceflightnow",
        require => Package["nginx"],
        notify => Exec["reload-nginx"] # Reload on new file.
    }

    file { '/etc/nginx/sites-enabled/spaceflightnow':
        ensure => 'link',
        target => '/etc/nginx/sites-available/spaceflightnow',
        require => [File["/etc/nginx/sites-available/spaceflightnow"],File["/srv/www/sfn"]],
        notify => Exec["reload-nginx"] # Reload on initial symbolic link.
    }
}
