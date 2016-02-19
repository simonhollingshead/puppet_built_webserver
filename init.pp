stage { 'first':
  before => Stage['main'],
}

class { "first":
    stage => first
}

include nginx
include munin
include python
include cv
include launchcalendar
include ntp
include utils
include users::simon
include coreservices
include domainwatch
