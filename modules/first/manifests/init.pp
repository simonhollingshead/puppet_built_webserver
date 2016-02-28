class first {
    #file { "/opt/flags":
    #    ensure => directory
    #}
    
    #exec { "add-universe":
    #    command => "/usr/bin/add-apt-repository \"deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse\"",
    #    user => root,
    #    creates => "/opt/flags/universe-added",
    #    notify => Exec["refresh-apt"],
    #    before => File["/opt/flags/universe-added"]
    #}
    
    #file { "/opt/flags/universe-added":
    #    ensure => file,
    #    require => File["/opt/flags"]
    #}
    
    exec { "refresh-apt":
        command => "/usr/bin/apt-get update",
        user => root,
        refreshonly => true
    }
	
	file { "/etc/dpkg/dpkg.cfg.d/01_nodoc":
		ensure => file,
		owner => root,
		group => root,
		mode => "0644",
		source => "puppet:///modules/first/dpkg_nodoc_conf"
	}
    
    package { "hiera-eyaml":
	    ensure => present,
        provider => puppet_gem
    }
    
    module { ['acme/ohmyzsh','saz/sudo','saz/ssh','willdurand/composer','puppetlabs/apt','puppetlabs/nodejs','elasticsearch/elasticsearch','puppetlabs/java']:
        ensure => present,
        modulepath => '/etc/puppetlabs/code/environments/production/modules'
    }
}
