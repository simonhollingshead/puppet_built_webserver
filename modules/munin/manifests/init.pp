class munin {
    package { "munin":
        ensure => present
    }
    
    package { "perl":
        ensure => present,
    }
    
    package { "libcgi-fast-perl":
        ensure => present,
        require => Package["perl"]
    }
    
    service { ["munin", "munin-node"]:
        status => running,
        require => Package["munin"]
    }
    
    exec { "reload-munin":
        command => "/usr/sbin/service munin-node restart",
        refreshonly => true,
        require => Service["munin-node"]
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
        mode => "0755",
        owner => root,
        group => root,
        source => "puppet:///modules/munin/munin-fastcgi",
        notify => Service["munin-fastcgi"]
    }
    
    service { "munin-fastcgi":
        ensure => running,
        require => [Service["munin"],Service["munin-node"],File["/etc/init.d/munin-fastcgi"],Package["fcgiwrap"],Package["libcgi-fast-perl"],File["/var/log/munin/munin-cgi-graph.log"],File["/var/log/munin/munin-cgi-html.log"]],
	enable => true,
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
    
    # Remove unwanted plugins
    file { ["/etc/munin/plugins/diskstats",
    "/etc/munin/plugins/df_inode",
    "/etc/munin/plugins/fw_packets",
    "/etc/munin/plugins/netstat",
    "/etc/munin/plugins/forks",
    "/etc/munin/plugins/vmstat",
    "/etc/munin/plugins/entropy",
    "/etc/munin/plugins/irqstats",
    "/etc/munin/plugins/open_inodes",
    "/etc/munin/plugins/interrupts",
    "/etc/munin/plugins/users",
    "/etc/munin/plugins/if_err_eth0"]:
        ensure => absent,
        notify => Exec["reload-munin"]
    }
}
