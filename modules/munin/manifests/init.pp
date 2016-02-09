class munin {
    package { "munin":
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
    
    file { "/etc/nginx/sites-available/munin":
        mode   => "0644",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/munin",
        require => Package["nginx"],
        notify => Exec["reload-nginx"] # Reload on new file.
    }
    
    file { '/etc/nginx/sites-enabled/munin':
        ensure => 'link',
        target => '/etc/nginx/sites-available/munin',
        require => File["/etc/nginx/sites-available/munin"],
        notify => Exec["reload-nginx"] # Reload on initial symbolic link.
    }
}
