class munin::packages ($overcast_email, $overcast_password) {
    file { "/usr/share/munin/plugins/karma.py":
        mode   => "0755",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/karma.py",
        require => [Package["munin"],Package["praw3"]],
	notify => Exec["reload-munin"] # Reload when file changes.
    }
    
    file { "/etc/munin/plugins/karma":
        ensure => link,
        target => "/usr/share/munin/plugins/karma.py",
        require => File["/usr/share/munin/plugins/karma.py"],
        notify => Exec["reload-munin"] # Reload when initially installed.
    }

    file { "/usr/share/munin/plugins/overcast.py":
        mode   => "0755",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/overcast.py",
        require => [Package["munin"],Package["python3-bs4"]],
	    notify => Exec["reload-munin"] # Reload when file changes.
    }
    
    file {"/etc/munin/plugin-conf.d/overcast":
        ensure => file,
        content => epp("munin/overcast_config.epp", {'email' => $overcast_email, 'password' => $overcast_password}),
        notify => Exec["reload-munin"] # Reload when config changed.
    }
    
    file { "/etc/munin/plugins/overcast":
        ensure => link,
        target => "/usr/share/munin/plugins/overcast.py",
        require => [File["/usr/share/munin/plugins/overcast.py"],File["/usr/share/munin/plugins/overcast.py"]],
        notify => Exec["reload-munin"] # Reload when initially installed.
    }
    
    package { "xmlstarlet":
        ensure => installed
    }
    
    file { "/usr/share/munin/plugins/ipv4_asn_ready":
        mode   => "0755",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/ipv4_asn_ready",
        require => [Package["munin"],Package["xmlstarlet"]],
	    notify => Exec["reload-munin"] # Reload when file changes.
    }
    
    file { "/etc/munin/plugins/ipv4_asn_ready":
        ensure => link,
        target => "/usr/share/munin/plugins/ipv4_asn_ready",
        require => File["/usr/share/munin/plugins/ipv4_asn_ready"],
        notify => Exec["reload-munin"] # Reload when initially installed.
    }
    
    file { "/usr/share/munin/plugins/ipv4_tld_ready":
        mode   => "0755",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/ipv4_tld_ready",
        require => [Package["munin"],Package["xmlstarlet"]],
	    notify => Exec["reload-munin"] # Reload when file changes.
    }
    
    file { "/etc/munin/plugins/ipv4_tld_ready":
        ensure => link,
        target => "/usr/share/munin/plugins/ipv4_tld_ready",
        require => File["/usr/share/munin/plugins/ipv4_tld_ready"],
        notify => Exec["reload-munin"] # Reload when initially installed.
    }
}
