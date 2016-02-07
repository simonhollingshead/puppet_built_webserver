stage { 'first':
  before => Stage['main'],
}

class { "apt":
    stage => first
}

include nginx
include munin
include python
include latex