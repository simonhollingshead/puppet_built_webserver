class app_minis {
	file { "/usr/bin/ac_calc":
		ensure => file,
		source => "puppet:///modules/app_minis/assetzcapital_distribution_calculator/assetzcapital_distribution_calculator.py",
		require => Package["python3"],
		owner => root,
		group => root,
		mode => "0755"
	}

	file { "/usr/bin/fc_calc":
		ensure => file,
		source => "puppet:///modules/app_minis/fundingcircle_gnucash_summariser/fundingcircle_gnucash_summariser.py",
		require => Package["python3"],
		owner => root,
		group => root,
		mode => "0755"
	}

	file { "/usr/bin/nfl_538":
		ensure => file,
		source => "puppet:///modules/app_minis/nfl_538_bridge/nfl_538_bridge.py",
		require => Package["python3"],
		owner => root,
		group => root,
		mode => "0755"
	}
}
