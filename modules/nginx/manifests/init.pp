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
}