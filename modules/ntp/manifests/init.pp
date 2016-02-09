class ntp {
    package { "ntp":
        ensure => installed
    }
    
    service { "ntp":
        ensure => running,
        require => Package["ntp"],
        notify => Exec["force-ntp-update"]
    }
    
    exec { "force-ntp-update":
        command => "/usr/sbin/ntpd -gq",
        refreshonly => true
    }
}