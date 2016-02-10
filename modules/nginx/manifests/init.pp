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
    
    package { ["php5-cli", "php5-cgi"]:
        ensure => present
    }
    
    file { "/var/run/php-fastcgi":
        ensure => directory,
        mode => "0755",
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
    
    file { "/etc/nginx/sites-available/default":
        mode   => "0644",
        owner  => root,
        group  => root,
        source => "puppet:///modules/nginx/default",
        require => Package["nginx"],
        notify => Exec["reload-nginx"] # Reload on new file.
    }
    
    file { '/etc/nginx/sites-enabled/default':
        ensure => 'link',
        target => '/etc/nginx/sites-available/default',
        require => File["/etc/nginx/sites-available/default"],
        notify => Exec["reload-nginx"] # Reload on initial symbolic link.
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