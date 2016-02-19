class nginx {
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
    
    package { "fcgiwrap":
        ensure => present,
        require => Service["nginx"]
    }
    
    package { "php5-cgi":
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
    
    file { "/etc/init.d/php-fastcgi":
        mode => "0755",
        owner => root,
        group => root,
        ensure => present,
        source => "puppet:///modules/nginx/php-fastcgi",
        require => [File["/var/run/php-fastcgi"],Package["php5-cgi"]]
    }
    
    service { "php-fastcgi":
        ensure => running,
        require => [Package["php5-cgi"],File["/etc/init.d/php-fastcgi"],Package["fcgiwrap"]],
	    enable => true,
        hasstatus => true
    }
   
    nginx::new_subdomain { "default":
	module => "nginx"
    }
 
    file { "/srv/www/default/media/bootstrap":
        ensure => 'link',
        target => '/srv/www/default/media/bootstrap-3.3.6',
        require => File["/srv/www/default"]
    }
    
    file { "/srv/www/default/media/jquery.min.js":
        ensure => 'link',
        target => '/srv/www/default/media/jquery-2.2.0.min.js',
        require => File["/srv/www/default"]
    }
    
    file { "/srv/www/default/media/font-awesome":
        ensure => 'link',
        target => '/srv/www/default/media/font-awesome-4.5.0',
        require => File["/srv/www/default"]
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
}
