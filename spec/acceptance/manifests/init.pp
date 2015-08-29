class acceptance {

  package { 'the package':
    ensure   => '1.2.3',
    provider => 'gem',
  }

  file { '/tmp/test':
    ensure  => present,
    content => 'the contents',
  }

  service { 'the service':
    ensure => running,
    enable => true,
  }

}
