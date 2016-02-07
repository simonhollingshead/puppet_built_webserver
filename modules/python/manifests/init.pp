class python {
	package { ["python","python3"]:
		ensure => present
	}
	
	package { "python-pip":
		ensure => present,
		require => Package["python"]
	}
	
	package { "python3-pip":
		ensure => present,
		require => Package["python3"]
	}
	
	package { "praw3":
	    name => "praw",
	    ensure => present,
	    require => Package["python3-pip"],
	    provider => pip3
	}
	
	package { "praw2":
	    name => "praw",
	    ensure => present,
	    require => Package["python-pip"],
	    provider => pip
	}
}
