class utils {
	package { ["vim","zsh","lynx","elinks","git","gitk","mtr","nmon","htop","nethogs","patch","rsync"]:
		ensure => present
	}
}
