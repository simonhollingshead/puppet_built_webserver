class launchcalendar {
	file { "/opt/launchcalendar.py":
		mode => "0555",
		source => "puppet:///modules/launchcalendar/launchcalendar.py",
		require => [Package["python3-icalendar"],Package["python3-bs4"],File["/srv/www/launchcalendar"]]
	}
	
	file { "/srv/www/launchcalendar/result.log":
		ensure => present,
		replace => no,
		content => "",
		owner => "www-data",
		group => "www-data",
		require => File["/srv/www/launchcalendar"]
	}
	
	cron { "launchcalendar":
		ensure => present,
		user => www-data,
		command => "/opt/launchcalendar.py > /srv/www/launchcalendar/result.log",
		minute => 0,
		require => [File["/opt/launchcalendar.py"],File["/srv/www/launchcalendar/result.log"]]
	}
	
	file { "/srv/www/launchcalendar":
        source => "puppet:///modules/launchcalendar/web-files",
        recurse => true,
        require => File["/srv/www"],
        owner => www-data,
        group => www-data,
        mode => "0644"
    }
    
    file { "/srv/www/launchcalendar/media":
        ensure => "link",
        target => "/srv/www/none/media",
        require => File["/srv/www/none"]
    }
    
    file { "/etc/nginx/sites-available/launchcalendar":
        mode   => "0644",
        owner  => root,
        group  => root,
        source => "puppet:///modules/launchcalendar/launchcalendar-nginx",
        require => Package["nginx"],
        notify => Exec["reload-nginx"] # Reload on new file.
    }

    file { '/etc/nginx/sites-enabled/launchcalendar':
        ensure => 'link',
        target => '/etc/nginx/sites-available/launchcalendar',
        require => [File["/etc/nginx/sites-available/launchcalendar"],File["/srv/www/launchcalendar"]],
        notify => Exec["reload-nginx"] # Reload on initial symbolic link.
    }
}
