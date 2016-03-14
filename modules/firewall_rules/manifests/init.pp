class firewall_rules {
	class { "firewall": }
	
	Firewall {
		before => Class["firewall_rules::post"],
		require => Class["firewall_rules::pre"]
	}
	
	resources { "firewall":
		purge => true
	}
	
	class { ["firewall_rules::pre","firewall_rules::post"]: }
}
