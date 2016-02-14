class domainwatch {
	package { "rabbitmq-server":
		ensure => installed
	}
	
	service { "rabbitmq-server":
		ensure => running
	}
	
	file { "/etc/nginx/sites-available/domainwatch":
        mode   => "0644",
        owner  => root,
        group  => root,
        source => "puppet:///modules/domainwatch/domainwatch-nginx",
        require => Package["nginx"],
        notify => Exec["reload-nginx"] # Reload on new file.
    }

    file { '/etc/nginx/sites-enabled/domainwatch':
        ensure => 'link',
        target => '/etc/nginx/sites-available/domainwatch',
        require => [File["/etc/nginx/sites-available/domainwatch"],File["/srv/www/domainwatch"]],
        notify => Exec["reload-nginx"] # Reload on initial symbolic link.
    }
    
    file { "/srv/www/domainwatch":
        source => "puppet:///modules/domainwatch/web-files",
        recurse => true,
        require => File["/srv/www"],
        owner => www-data,
        group => www-data,
        mode => "0644"
    }
    
    exec { "domainwatch-composer":
        user => root,
        environment => ["HOME=/root"],
        command => "/usr/local/bin/composer install",
        cwd => "/srv/www/domainwatch",
        require => [Class["composer"],File["/srv/www/domainwatch"]]
    }
    
    file { "/srv/www/domainwatch/media":
        ensure => "link",
        target => "/srv/www/none/media",
        require => File["/srv/www/none"]
    }
    
    package { "ruby2.0":
        ensure => installed
    }
    
    file { "/usr/bin/ruby":
        ensure => link,
        target => "/usr/bin/ruby2.0",
        require => Package["ruby2.0"]
    }
    
    file { "/usr/bin/gem":
        ensure => link,
        target => "/usr/bin/gem2.0",
        require => Package["ruby2.0"]
    }
    
    package { "bunny":
        ensure => installed,
        provider => gem,
        require => File["/usr/bin/gem"]
    }

}
