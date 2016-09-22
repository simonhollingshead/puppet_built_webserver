class domainwatch {
	package { "rabbitmq-server":
		ensure => installed
	}
	
	service { "rabbitmq-server":
		ensure => running
	}

	nginx::new_subdomain{ "domainwatch": }
	
	
	# Composer installs the AMQP libraries, which require BCMATH and MBSTRING support.
	
	package { ["php-bcmath", "php-mbstring"]:
		ensure => installed
	}
	
    exec { "domainwatch-composer":
        user => www-data,
        environment => ["HOME=/root"],
        command => "/usr/local/bin/composer update --no-dev",
        cwd => "/srv/www/domainwatch",
        require => [Class["composer"],File["/srv/www/domainwatch"], Package["php-bcmath"], Package["php-mbstring"]]
    }
    
    package { "ruby":
        ensure => installed
    }
    
    package { ["bunny","whois"]:
        ensure => installed,
        provider => gem,
        require => Package["ruby"]
    }

    file { "/opt/domainwatch":
	ensure => directory,
	mode => "0775"
    }
	
    file { "/opt/domainwatch/listener":
	ensure => present,
	source => "puppet:///modules/domainwatch/listener.rb",
	mode => "0775",
	require => File["/opt/domainwatch"]
    }

	elasticsearch::instance { 'es-01': 
		config => {
			'node' => {
				'name' => "es01",
				'master' => "true",
				'data' => "true"
			},
			'index' => {
				'number_of_shards' => "1",
				'number_of_replicas' => "0"
			},
			'http.cors' => {
				'enabled' => "true",
				'allow-origin' => '"*"',
				'allow-methods' => 'OPTIONS, HEAD, GET, POST, PUT, DELETE',
				'allow-headers' => 'X-Requested-With,X-Auth-Token,Content-Type,Content-Length'
			},
			'cluster.routing.allocation.disk.threshold_enabled' => "false",
			'discovery.zen.ping.multicast.enabled' => "false"
		}
	}
}
