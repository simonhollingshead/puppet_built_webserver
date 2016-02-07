class munin::packages {
    file { "/usr/share/munin/plugins/karma.py":
        mode   => "0755",
        owner  => root,
        group  => root,
        source => "puppet:///modules/munin/karma.py",
        require => [Package["munin"],Package["praw3"]]
    }
    
    file { "/etc/munin/plugins/karma":
        ensure => link,
        target => "/usr/share/munin/plugins/karma.py",
        require => File["/usr/share/munin/plugins/karma.py"],
        notify => Exec["reload-munin"]
    }
}
