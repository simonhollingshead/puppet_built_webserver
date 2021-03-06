class nginx($letsencrypt_email) {
    package { ['bower', 'npm-check-updates']:
        ensure   => 'present',
        provider => 'npm',
        require => File["/usr/bin/node"]
    }
    
    package { "apache2":
        ensure => absent
    }
    
    package { "nginx":
        ensure => present,
        require => Package["apache2"]
    }
    
    service { "nginx":
        status => running,
        require => Package["nginx"]
    }
    
    firewall { "080 allow access to webserver":
        proto => "tcp",
        dport => "http",
        action => accept,
        require => Service["nginx"]
    }
    
    package { "fcgiwrap":
        ensure => present,
        require => Service["nginx"]
    }
    
    package { "php-cgi":
        ensure => present
    }
    
    file { "/var/run/php-fastcgi":
        ensure => directory,
        mode => "0755",
        owner => www-data,
        group => www-data
    }
    
    file { "/srv/www":
        ensure => directory,
        mode => "0775",
        owner => www-data,
        group => www-data
    }

    file { "/var/www":
	ensure => directory,
        mode => "0775",
        owner => www-data,
        group => www-data
    }

	exec { "bower-install-media":
		environment => ["HOME=/var/www"],
		command => "/usr/local/bin/bower install && /usr/local/bin/bower update",
		cwd => "/srv/www/default/media",
		user => www-data,
		group => www-data,
		require => [File["/srv/www/default"],File["/var/www"],Package["bower"]]
	}
	
	#exec { "bower-show-updates":
	#	environment => ["HOME=/var/www"].
	#	command => "/usr/local/bin/bower list",
	#	cwd => "/srv/www/default/media",
	#	user => www-data,
	#	group => www-data,
	#	require => Exec["bower-install-media"],
	#	logoutput => true
	#}
    
    file { "/etc/init.d/php-fastcgi":
        mode => "0755",
        owner => root,
        group => root,
        ensure => present,
        source => "puppet:///modules/nginx/php-fastcgi",
        require => [File["/var/run/php-fastcgi"],Package["php-cgi"]]
    }
    
    service { "php-fastcgi":
        ensure => running,
        require => [Package["php-cgi"],File["/etc/init.d/php-fastcgi"],Package["fcgiwrap"]],
	enable => true,
        hasstatus => true
    }
   
    nginx::new_subdomain { "default":
	module => "nginx"
    }
 
    file { "/srv/www/default/media/bootstrap":
        ensure => 'link',
        target => '/srv/www/default/media/bower_components/bootstrap/dist',
        require => Exec["bower-install-media"]
    }
    
    file { "/srv/www/default/media/jquery":
        ensure => 'link',
        target => '/srv/www/default/media/bower_components/jquery/dist',
        require => Exec["bower-install-media"]
    }
    
    file { "/srv/www/default/media/font-awesome":
        ensure => 'link',
        target => '/srv/www/default/media/bower_components/fontawesome',
        require => Exec["bower-install-media"]
    }
	
	class { ::letsencrypt:
		email => $letsencrypt_email,
	}
    
    exec {
    "reload-nginx" :
      refreshonly => true,
      command => "/usr/sbin/service nginx reload",
      require => Package["nginx"];

    "restart-nginx" :
      refreshonly => true,
      command => "/usr/sbin/service nginx restart",
      require => Package["nginx"];
  }
	
	dnsmasq::conf { 'internal-subdomain-access':
		ensure => present,
		content => 'address=/.nginx.internal/127.0.0.1'
	}
	
	monit::add_monitor { "nginx":
		source => "puppet:///modules/nginx/monit/nginx.conf"
	}
}
