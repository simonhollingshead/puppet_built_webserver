class apt {
    exec { "add-universe":
        command => "/usr/bin/add-apt-repository \"deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse\"",
        user => root
    }
    
    exec { "apt-update":
        command => "/usr/bin/apt-get update",
        user => root,
        require => Exec["add-universe"]
    }
}