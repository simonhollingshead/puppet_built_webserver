class domainwatch {
	package { "rabbitmq-server":
		ensure => installed
	}
	
	service { "rabbitmq-server":
		ensure => running
	}

	nginx::new_subdomain{ "domainwatch": }
		
    exec { "domainwatch-composer":
        user => root,
        environment => ["HOME=/root"],
        command => "/usr/local/bin/composer install",
        cwd => "/srv/www/domainwatch",
        require => [Class["composer"],File["/srv/www/domainwatch"]]
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
