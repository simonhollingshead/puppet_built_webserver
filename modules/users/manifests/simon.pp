class users::simon ($password,$github_key) {
    package { "zsh":
    	ensure => installed
    }

    user { "simon":
        ensure => present,
        comment => "Simon Hollingshead",
        password => pw_hash($password, 'SHA-512', 'HhG9MFOeybJxPYx1W4fDv8VRSsZrbSCFIihOdp931Chd823BPbKnRYbaIDRayMD'),
        managehome => yes,
        home => "/home/simon",
        purge_ssh_keys => true,
        shell => "/usr/bin/zsh",
        require => Package["zsh"]
    }

	file { "/home/simon/.ssh/github_rsa":
		ensure => file,
		mode => "0600",
		owner => simon,
		group => simon,
		content => "$github_key",
		require => File["/home/simon/.ssh"]
	}
	
	file { "/root/.ssh":
		ensure => directory,
		mode => "0700",
		owner => root,
		group => root,
	}
	
	file { "/root/.ssh/id_rsa":
		ensure => file,
		mode => "0600",
		owner => root,
		group => root,
		content => "$github_key",
		require => File["/root/.ssh"]
	}

    ssh_authorized_key { "simon@putty":
        user => 'simon',
        type => 'ssh-rsa',
        key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA9tjbG2Roml+7VYrJEfSa4FnzAmwtXz4kZX8okDCmWvLPenUYncRBn90qbyvvPKO2Q4Za+zKl76G5xZq7K0gvd5oLAkmIQ5x32hrpgSn4RMis+rU2dbbv8TuvA02Ia9eniX2EUuwteKbjHVPz9UVUNWTdcYLnXmAILNSB/9dRyLaGjZWXAk4clj5FJ+/T4aJ0IAjnZYVzsMamaZoOA2M2ZngDRwUcCIBf3SPHL46YQSRZZJ4mGJpSc+l99Loqgts6FjaGRioV0C2z/gLMwYb2RqeD30yT3N7Ze0gtDJGMU2VuqY80FfBWRtzdKUmqBy55D7yu6pbQA4SRcWWEGR1SDw==',
        require => User["simon"]
    }

    class { 'sudo': }
    sudo::conf { 'simon':
      priority => 10,
      content  => "simon ALL=(ALL) ALL",
      require => User["simon"]
    }

    # TODO: Remove me when no longer using Koding.
    sudo::conf { 'simonhollingshead':
      priority => 10,
      content  => "simonhollingshead ALL=(ALL) NOPASSWD:ALL"
    }

    class { 'ohmyzsh': 
        require => [User["simon"],Package["zsh"]]
    }
    ohmyzsh::install { 'simon': }
    ohmyzsh::upgrade { 'simon': }
    ohmyzsh::theme { 'simon': theme => 'ys' }
    ohmyzsh::plugins { 'simon': plugins => 'command-not-found common-aliases compleat cpanm debian git gitfast git-extras git-flow history pip python screne sprunge sudo' }

    file { "/home/simon/.gitconfig":
	source => "puppet:///modules/users/simon.gitconfig",
	mode => "0644",
	owner => simon,
	group => simon,
	require => [User["simon"]]
    }
	
    file { "/root/.gitconfig":
	source => "puppet:///modules/users/simon.gitconfig",
        mode => "0644",
        owner => root,
        group => root
    }
}
