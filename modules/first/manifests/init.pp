class first ($simon_password) {
    file { "/opt/flags":
        ensure => directory
    }
    
    exec { "add-universe":
        command => "/usr/bin/add-apt-repository \"deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse\"",
        user => root,
        creates => "/opt/flags/universe-added",
        notify => Exec["apt-update"],
        before => File["/opt/flags/universe-added"]
    }
    
    file { "/opt/flags/universe-added":
        ensure => file,
        require => File["/opt/flags"]
    }
    
    exec { "apt-update":
        command => "/usr/bin/apt-get update",
        user => root,
        refreshonly => true
    }
    
    package { "ruby":
	    ensure => present
    }
    
    package { "hiera-eyaml":
	    ensure => present,
        provider => gem,
	    require => Package["ruby"]
    }
    
    package { "zsh":
        ensure => installed
    }
    
    user { "simon":
        ensure => present,
        comment => "Simon Hollingshead",
        password => pw_hash($simon_password, 'SHA-512', 'HhG9MFOeybJxPYx1W4fDv8VRSsZrbSCFIihOdp931Chd823BPbKnRYbaIDRayMD'),
        managehome => yes,
        home => "/home/simon",
        purge_ssh_keys => true,
        shell => "/usr/bin/zsh",
        require => Package["zsh"]
    }
    
    ssh_authorized_key { "simon@putty":
        user => 'simon',
        type => 'ssh-rsa',
        key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA9tjbG2Roml+7VYrJEfSa4FnzAmwtXz4kZX8okDCmWvLPenUYncRBn90qbyvvPKO2Q4Za+zKl76G5xZq7K0gvd5oLAkmIQ5x32hrpgSn4RMis+rU2dbbv8TuvA02Ia9eniX2EUuwteKbjHVPz9UVUNWTdcYLnXmAILNSB/9dRyLaGjZWXAk4clj5FJ+/T4aJ0IAjnZYVzsMamaZoOA2M2ZngDRwUcCIBf3SPHL46YQSRZZJ4mGJpSc+l99Loqgts6FjaGRioV0C2z/gLMwYb2RqeD30yT3N7Ze0gtDJGMU2VuqY80FfBWRtzdKUmqBy55D7yu6pbQA4SRcWWEGR1SDw==',
        require => User["simon"]
    }
    
    class { 'sudo': }
    sudo::conf { 'simon':
      priority => 10,
      content  => "simon ALL=(ALL) ALL"
    }
    # TODO: Remove me when no longer using Koding.
    sudo::conf { 'simonhollingshead':
      priority => 10,
      content  => "simonhollingshead ALL=(ALL) NOPASSWD:ALL"
    }
}
