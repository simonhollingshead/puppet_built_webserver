class puppet {
	file { "/opt/puppetlabs/puppet/cache":
		ensure => directory,
		mode => "0755"
	}
	
	package { "graphviz":
		ensure => installed
	}
	
	nginx::new_subdomain{ "puppet": }
	
	exec { "/usr/bin/dot -Tpdf /opt/puppetlabs/puppet/cache/state/graphs/expanded_relationships.dot -o /srv/www/puppet/dependency_graph.pdf":
		require => [File["/srv/www/puppet"],Package["graphviz"],File["/opt/puppetlabs/puppet/cache"]],
		user => www-data
	}
}	
