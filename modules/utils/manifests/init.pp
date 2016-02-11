class utils {
	package { ["vim","lynx","elinks","git","gitk","mtr","nmon","htop","nethogs","patch","rsync"]:
		ensure => present
	}
}
