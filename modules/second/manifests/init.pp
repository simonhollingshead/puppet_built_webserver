class second {
	#class { 'elasticsearch':
	#    java_install => true,
        #    manage_repo  => true,
        #    repo_version => '2.x',
	#    config => { 'cluster.name' => 'domainwatch' }
	#}
	
	class { 'unattended_upgrades': 
		random_sleep => 100
	}
	
	package { 'ureadahead':
		ensure => present
	}
}
