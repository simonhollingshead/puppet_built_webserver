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
        require => [File["/usr/share/munin/plugins/overcast.py"],File["/etc/munin/plugin-conf.d/overcast"]],
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
    
    file { "/usr/share/munin/plugins/ratesetter":
        mode   => "0755",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/ratesetter",
        require => Package["munin"],
	    notify => Exec["reload-munin"] # Reload when file changes.
    }
    
    file { "/etc/munin/plugins/ratesetter":
        ensure => link,
        target => "/usr/share/munin/plugins/ratesetter",
        require => File["/usr/share/munin/plugins/ratesetter"],
        notify => Exec["reload-munin"] # Reload when initially installed.
    }
    
    file { "/usr/share/munin/plugins/ntp_kernel_err":
        mode   => "0755",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/ntp_kernel_err",
        require => [Package["munin"],Package["ntp"]],
	    notify => Exec["reload-munin"] # Reload when file changes.
    }
    
    file { "/etc/munin/plugins/ntp_kernel_err":
        ensure => link,
        target => "/usr/share/munin/plugins/ntp_kernel_err",
        require => File["/usr/share/munin/plugins/ntp_kernel_err"],
        notify => Exec["reload-munin"] # Reload when initially installed.
    }
    
    file { "/usr/share/munin/plugins/ntp_packets.pl":
        mode   => "0755",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/ntp_packets.pl",
        require => [Package["munin"],Package["ntp"],Package["perl"]],
	    notify => Exec["reload-munin"] # Reload when file changes.
    }
    
    file { "/etc/munin/plugins/ntp_packets.pl":
        ensure => link,
        target => "/usr/share/munin/plugins/ntp_packets.pl",
        require => File["/usr/share/munin/plugins/ntp_packets.pl"],
        notify => Exec["reload-munin"] # Reload when initially installed.
    }
    
    file { "/usr/share/munin/plugins/apt_all.pl":
        mode   => "0755",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/apt_all.pl",
        require => [Package["munin"],Package["perl"]],
	    notify => Exec["reload-munin"] # Reload when file changes.
    }
    
    file { "/etc/munin/plugins/apt_all.pl":
        ensure => link,
        target => "/usr/share/munin/plugins/apt_all.pl",
        require => File["/usr/share/munin/plugins/apt_all.pl"],
        notify => Exec["reload-munin"] # Reload when initially installed.
    }
}
