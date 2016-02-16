class first {
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
    
    package { "hiera-eyaml":
	    ensure => present,
        provider => puppet_gem
    }
    
    module { ['acme/ohmyzsh','saz/sudo','saz/ssh','willdurand/composer', 'basti1302/wait_for']:
        ensure => present,
        modulepath => '/etc/puppetlabs/code/environments/production/modules'
    }
}
