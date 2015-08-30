class acceptance {

  include another::class

  package { 'the package':
    ensure   => $another,
    provider => 'gem',
  }

  file { '/tmp/test':
    ensure  => present,
    content => $::osfamily,
  }

  service { 'the service':
    ensure => running,
    enable => true,
  }

  another::type { 'the other thing':
    ensure => 'around',
  }

}
