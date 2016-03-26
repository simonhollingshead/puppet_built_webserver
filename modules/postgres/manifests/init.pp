class postgres ($db_admin_password) {
	class { 'postgresql::server':
		postgres_password => $db_admin_password
	}
	
	wget::fetch { "Flyway":
		source => "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.0/flyway-commandline-4.0.tar.gz",
		destination => "/opt/flyway.tar.gz",
		cache_dir => "/var/cache/wget",
	}
		
	exec { "Extract Flyway":
		command => "/bin/tar -C /opt/ -xf /opt/flyway.tar.gz",
		refreshonly => true,
		subscribe => File["/opt/flyway.tar.gz"]
	}	
}
