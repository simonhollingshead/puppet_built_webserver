class munin {
    package { "munin":
        ensure => present
    }
    
    package { "libcgi-fast-perl":
        ensure => present
    }
    
    service { ["munin", "munin-node"]:
        status => running,
        require => Package["munin"]
    }
    
    exec { "reload-munin":
        command => "/usr/sbin/service munin-node restart",
        refreshonly => true
    }
 
    include munin::packages
    
    file { "/etc/logrotate.d/munin":
        mode   => "0644",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/munin_logrotate",
        require => Package["munin"]
    }
    
    file { ["/var/log/munin/munin-cgi-graph.log","/var/log/munin/munin-cgi-html.log"]:
        ensure => present,
        require => [Package["munin"],File["/etc/logrotate.d/munin"]],
        owner => munin,
        group => munin,
        mode => "0644"
    }
    
    file { "/etc/init.d/munin-fastcgi":
        mode => "0744",
        owner => root,
        group => root,
        source => "puppet:///modules/munin/munin-fastcgi",
        notify => Service["munin-fastcgi"]
    }
    
    service { "munin-fastcgi":
        ensure => running,
        require => [Service["munin"],File["/etc/init.d/munin-fastcgi"],Package["fcgiwrap"],Package["libcgi-fast-perl"]],
        hasstatus => true
    }
    
    file { "/etc/nginx/sites-available/munin":
        mode   => "0644",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/munin_nginx",
        require => [Package["nginx"],Package["fcgiwrap"],Package["libcgi-fast-perl"]],
        notify => Exec["reload-nginx"] # Reload on new file.
    }
    
    file { '/etc/nginx/sites-enabled/munin':
        ensure => 'link',
        target => '/etc/nginx/sites-available/munin',
        require => File["/etc/nginx/sites-available/munin"],
        notify => Exec["reload-nginx"] # Reload on initial symbolic link.
    }
}
