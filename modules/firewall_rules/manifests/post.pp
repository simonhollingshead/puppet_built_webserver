class firewall_rules::post {
	firewall { "999 block all":
		proto => "all",
		action => "drop",
		before => undef
	}
}
