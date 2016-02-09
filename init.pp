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
include spaceflightnow
include ntp