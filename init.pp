stage { 'first':
  before => Stage['main'],
}

class { "first":
    stage => first
}

include nginx
include munin
include python
#include latex
include launchcalendar
include ntp
include utils
include users
include coreservices
include domainwatch