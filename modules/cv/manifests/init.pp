class cv ($nginx_redirects) {
    # texlive-latex-recommended is to install xcolor, which is no longer a separate package.
    package { ["texlive-xetex","texlive-latex-recommended","texlive-math-extra","texlive-latex-extra"]:
        ensure => present
    }
	
	file { "/usr/share/fonts/helveticaneue":
		ensure => directory,
		recurse => true,
		source => "puppet:///modules/cv/helveticaneue",
		purge => true,
		owner => root,
		group => root,
		mode => "0644",
		ignore => ["*.gpg",".gitignore"]
	}
	
	nginx::new_subdomain{ "cv":
		redirects => $nginx_redirects
	}
	
	file { "/opt/cv":
		owner => www-data,
		group => www-data,
		ensure => directory,
		mode => "0644",
		require => Package["nginx"]
	}
	
	file { "/opt/cv/cv-inverted.tex":
		owner => www-data,
		group => www-data,
		ensure => file,
		mode => "0644",
		content => epp("cv/cv", {'print' => false}),
		require => File["/opt/cv"],
		notify => Exec["build-cv"]
	}
	
	file { "/opt/cv/cv-print.tex":
		owner => www-data,
		group => www-data,
		ensure => file,
		mode => "0644",
		content => epp("cv/cv", {'print' => true}),
		require => File["/opt/cv"],
		notify => Exec["build-cv"]
	}
	
	file { "/opt/cv/friggeri-cv.cls":
                owner => www-data,
                group => www-data,
		ensure => file,
                mode => "0644",
                source => "puppet:///modules/cv/friggeri-cv.cls",
                require => File["/opt/cv"],
		notify => Exec["build-cv"]
        }
	
	exec { "build-cv":
		refreshonly => true,
		cwd => "/opt/cv",
		command => "/usr/bin/xelatex cv-inverted.tex && /usr/bin/xelatex cv-inverted.tex && /usr/bin/xelatex cv-inverted.tex && cp cv-inverted.pdf /srv/www/cv/cv.pdf && /usr/bin/xelatex cv-print.tex && /usr/bin/xelatex cv-print.tex && /usr/bin/xelatex cv-print.tex && cp cv-print.pdf /srv/www/cv/cv_bw.pdf && rm -f *.aux *.bcf *.log *.out *.run.xml",
		user => www-data,
		group => www-data,
		require => [File["/opt/cv/cv-inverted.tex"],File["/opt/cv/cv-print.tex"],File["/opt/cv/friggeri-cv.cls"],Package["texlive-xetex"],Package["texlive-latex-recommended"],Package["texlive-math-extra"],Package["texlive-latex-extra"],File["/usr/share/fonts/helveticaneue"],File["/srv/www/cv"]]
	}
	
	monit::add_monitor { "cv":
		source => "puppet:///modules/cv/monit/cv.conf",
		require => File["/srv/www/cv"]
	}
}
