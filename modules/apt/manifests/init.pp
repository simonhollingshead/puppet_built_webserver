class apt {
    # TODO: Validate if needed before performing, so we don't always have to update apt.
    exec { "add-universe":
        command => "/usr/bin/add-apt-repository \"deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse\"",
        user => root,
        notify => Exec["apt-update"]
    }
    
    exec { "apt-update":
        command => "/usr/bin/apt-get update",
        user => root,
        refreshonly => true
    }
}