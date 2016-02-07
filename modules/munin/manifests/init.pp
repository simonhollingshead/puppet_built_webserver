class munin {
    package { "munin":
        ensure => present
    }
    
    service { ["munin", "munin-node"]:
        status => running,
        require => Package["munin"]
    }
    
    include munin::packages
    
    file { "/etc/nginx/sites-enabled/default":
        mode   => "0644",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/default",
        require => Package["nginx"],
        notify => Exec["reload-nginx"]
    }
}