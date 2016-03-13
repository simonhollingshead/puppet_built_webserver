class first {
    #file { "/opt/flags":
    #    ensure => directory
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
    
    package { "npm":
        ensure => present
    }
    
    file { "/usr/bin/node":
        ensure => link,
        target => "/usr/bin/nodejs",
        require => Package["npm"]
    }
 
    module { ['acme/ohmyzsh','saz/sudo','saz/ssh','willdurand/composer','puppetlabs/apt','elasticsearch/elasticsearch','puppetlabs/java']:
        ensure => present,
        modulepath => '/etc/puppetlabs/code/environments/production/modules'
    }
}
