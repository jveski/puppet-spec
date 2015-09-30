class acceptance {

  class { 'another::class':
    param        => "value",
    lkjsdflkjsdf => "123",
  }

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

  file { '/tmp/test2':
    ensure  => present,
    content => "stub content\n",
  }

}
