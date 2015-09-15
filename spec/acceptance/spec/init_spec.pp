stub_facts({
  osfamily => 'the contents',
  another  => '1.2.3',
})

stub_class("another::class")

stub_type("another::type")

include acceptance

assertion { 'that the package should be the correct version':
  subject     => Package['the package'],
  attribute   => 'ensure',
  expectation => '1.2.3',
}

assertion { 'that the configuration file has the correct contents':
  subject     => File['/tmp/test'],
  attribute   => 'content',
  expectation => 'not the contents',
}

assertion { 'that the service should start on boot':
  subject     => Service['the service'],
  attribute   => 'enable',
  expectation => true,
}

assertion { 'that the class containing all the other stuff should be included':
  subject => Class['another::class'],
}

assertion { 'that the class should have a gibberish attribute':
  subject     => Class['another::class'],
  attribute   => 'lkjsdflkjsdf',
  expectation => '123',
}

assertion { 'that the other thing is around':
  subject     => Another::Type['the other thing'],
  attribute   => 'ensure',
  expectation => 'around',
}

assertion { 'that the resource is in the catalog':
  subject => File['/tmp/should/be/around'],
}

assertion { 'that the undesired file is not in the catalog':
  ensure  => absent,
  subject => File['/tmp/should/not/be/around'],
}
