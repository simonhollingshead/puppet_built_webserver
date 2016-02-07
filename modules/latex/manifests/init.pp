class latex {
    # TODO: See if texlive-full is needed.
    package { "texlive":
        ensure => present
    }
}