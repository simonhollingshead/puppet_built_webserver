class latex {
    package { ["texlive-xetex","latex-xcolor","texlive-math-extra","texlive-latex-extra","texlive-bibtex-extra"]:
        ensure => present
    }
	
	file { "/usr/share/fonts/helveticaneue":
		ensure => directory,
		recurse => true,
		source => "puppet:///modules/latex/helveticaneue",
		purge => true,
		owner => root,
		group => root,
		mode => "0644",
		ignore => "*.gpg"
	}
}
