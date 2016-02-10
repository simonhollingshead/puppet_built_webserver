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
    
    exec { "reload-ntp" :
      refreshonly => true,
      command => "/usr/sbin/service ntp force-reload",
      require => Package["ntp"];
    }

    file { "/etc/ntp.conf":
        ensure => present,
        mode => "0644",
        source => "puppet:///modules/ntp/ntp.conf",
        require => Package["ntp"],
        notify => Exec["reload-ntp"]
    }
}