class firewall_rules::pre {
	Firewall {
		require => undef
	}
	firewall { '000 accept all icmp':
		proto => "icmp",
		action => "accept"
	}->
	firewall { '001 accept all to loopback':
		proto => "all",
		iniface => "lo",
		action => "accept"
	}->
	firewall { '002 reject 127.x not on loopback':
		iniface => "! lo",
		proto => "all",
		destination => "127.0.0.1/8",
		action => "reject"
	}->
	firewall { '003 accept RELATED and ESTABLISHED':
		proto => "all",
		state => ["RELATED","ESTABLISHED"],
		action => "accept"
	}		
}
