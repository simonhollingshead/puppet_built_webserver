class postgres ($db_admin_password) {
	class { 'postgresql::server':
		postgres_password => $db_admin_password
	}
	
	wget::fetch { "Flyway":
		source => "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.0.3/flyway-commandline-4.0.3.tar.gz",
		destination => "/opt/flyway.tar.gz",
		cache_dir => "/var/cache/wget",
	}
	
	file { "/opt/flyway":
		ensure => directory,
		mode => "0755",
		owner => root,
		group => root
	}
		
	exec { "Extract Flyway":
		command => "/bin/tar -C /opt/flyway -xf /opt/flyway.tar.gz --strip-components 1",
		refreshonly => true,
		subscribe => File["/opt/flyway.tar.gz"],
		require => File["/opt/flyway"]
	}
	
	file { "/sql":
		ensure => "directory",
		mode => "0400",
		owner => "root",
		group => "root"
	}
}
