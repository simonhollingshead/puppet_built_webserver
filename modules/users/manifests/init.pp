class users {
	group { "wheel":
		ensure => present
	}
	
 	class { 'sudo': }
	sudo::conf { 'wheel':
 		priority => 10,
		content  => "%wheel ALL=(ALL) ALL",
		require => Group["wheel"]
 	}
}
