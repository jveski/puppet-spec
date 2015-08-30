stub_facts({
  osfamily => 'the contents',
  another  => '1.2.3',
})

include acceptance

assertion { 'the package should be the correct version':
  subject     => Package['the package'],
  attribute   => 'ensure',
  expectation => '1.2.3',
}

assertion { 'the configuration file has the correct contents':
  subject     => File['/tmp/test'],
  attribute   => 'content',
  expectation => 'not the contents',
}

assertion { 'the service should start on boot':
  subject     => Service['the service'],
  attribute   => 'enable',
  expectation => true,
}
