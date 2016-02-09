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