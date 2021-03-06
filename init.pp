stage { 'first':
  before => Stage['second']
}

stage { 'second':
  before => Stage['main']
}

class { "first":
    stage => first
}

class { "second":
    stage => second
}

include firewall_rules
include nginx
include munin
include python
include cv
# include launchcalendar
include ntp
include utils
include users
include users::simon
include coreservices
# include domainwatch
include puppet
include postgres
include monit
include app_minis
