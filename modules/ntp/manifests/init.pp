class ntp {
    package { "ntp":
        ensure => installed
    }
    
    service { "ntp":
        ensure => running,
        require => [Package["ntp"],File["/etc/ntp.conf"]],
        notify => Exec["force-ntp-update"]
    }
    
    firewall { "123 allow access to ntp":
        proto => "udp",
        dport => "ntp",
        action => "accept",
        require => Service["ntp"]
    }
    
    exec { "force-ntp-update":
        command => "/usr/sbin/ntpd -gq",
        refreshonly => true,
        require => Package["ntp"];
    }
    
    exec { "reload-ntp" :
      refreshonly => true,
      command => "/usr/sbin/service ntp force-reload",
      require => Package["ntp"];
    }

    file { "/etc/ntp.conf":
        ensure => file,
        mode => "0644",
        source => "puppet:///modules/ntp/ntp.conf",
        require => Package["ntp"],
        notify => Exec["reload-ntp"]
    }
	
	file { "/etc/monit/ntp_est_error.sh":
		ensure => file,
		mode => "0755",
		source => "puppet:///modules/ntp/monit/ntp_est_error.sh",
		require => Package["monit"]
	}
	
	monit::add_monitor { "ntp":
		source => "puppet:///modules/ntp/monit/ntp.conf"
	}
}
