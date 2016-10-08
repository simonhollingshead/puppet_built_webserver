define nginx::new_subdomain ($subdomain = $title, $module = "/", $redirects = []) {
	$modulename = $module ? {
		"/" => $subdomain,
		default => $module
	}

	file { "/srv/www/$subdomain":
		ensure => directory,
		recurse => true,
		source => "puppet:///modules/$modulename/web-files",
		require => File["/srv/www"],
		owner => www-data,
		group => www-data,
		mode => "0644"
	}
	
	file { "/etc/nginx/sites-available/$subdomain":
		ensure => file,
		mode => "0644",
		owner => root,
		group => root,
		require => Package["nginx"],
		notify => Exec["reload-nginx"],
		content => epp('nginx/site_conf', {'subdomain' => $subdomain, 'redirects' => $redirects})
	}
	
	file { "/etc/nginx/sites-enabled/$subdomain":
		ensure => link,
		target => "/etc/nginx/sites-available/$subdomain",
		require => [File["/etc/nginx/sites-available/$subdomain"],File["/srv/www/$subdomain"]],
		notify => Exec["reload-nginx"]
	}
	
	if $subdomain != "default" {
		file { "/srv/www/$subdomain/media":
			ensure => link,
			target => "/srv/www/default/media",
			require => File["/srv/www/default"]
		}
	}
	
	monit::add_monitor { "$subdomain.nginx.internal":
		use_template => true,
		content => epp('nginx/monit_domain.conf.epp', {'subdomain' => $subdomain})
	}
}
