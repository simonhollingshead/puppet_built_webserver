class second {
    class { "nodejs": }

class { 'elasticsearch':
	    java_install => true,
            manage_repo  => true,
            repo_version => '2.x',
	    config => { 'cluster.name' => 'domainwatch' }
}
}
