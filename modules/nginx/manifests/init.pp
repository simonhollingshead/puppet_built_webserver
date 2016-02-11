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
    
    file { "/etc/nginx/sites-available/default":
        mode   => "0644",
        owner  => root,
        group  => root,
        source => "puppet:///modules/nginx/default",
        require => Package["nginx"],
        notify => Exec["reload-nginx"] # Reload on new file.
    }
    
    file { "/srv/www/none":
        source => "puppet:///modules/nginx/web-files",
        recurse => true,
        require => File["/srv/www"],
        owner => www-data,
        group => www-data,
        mode => "0644"
    }
    
    file { "/srv/www/none/media/bootstrap":
        ensure => 'link',
        target => '/srv/www/none/media/bootstrap-3.3.6',
        require => File["/srv/www/none"]
    }
    
    file { "/srv/www/none/media/jquery.min.js":
        ensure => 'link',
        target => '/srv/www/none/media/jquery-2.2.0.min.js',
        require => File["/srv/www/none"]
    }
    
    file { "/srv/www/none/media/font-awesome":
        ensure => 'link',
        target => '/srv/www/none/media/font-awesome-4.5.0',
        require => File["/srv/www/none"]
    }
    
    file { '/etc/nginx/sites-enabled/default':
        ensure => 'link',
        target => '/etc/nginx/sites-available/default',
        require => [File["/etc/nginx/sites-available/default"],File["/srv/www/none"]],
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