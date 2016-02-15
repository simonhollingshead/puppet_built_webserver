class latex {
    package { ["texlive-xetex","latex-xcolor","texlive-math-extra"]:
        ensure => present
    }
}
