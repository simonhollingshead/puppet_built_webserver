class utils {
	package { ["vim","lynx","elinks","git","gitk","mtr","nmon","htop","nethogs","patch","rsync"]:
		ensure => present
	}
	
	# TODO: Remove when no longer using Koding.
	package { ["golang-go","golang-go-linux-amd64","puppetserver"]:
	    ensure => purged
	}
}
