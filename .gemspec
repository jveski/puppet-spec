Gem::Specification.new do |s|
  s.name                  = 'puppet-spec'
  s.version               = '1.0.0'
  s.license               = 'Apache-2.0'
  s.platform              = Gem::Platform::RUBY
  s.homepage              = 'http://github.com/jolshevski/puppet-spec'
  s.summary               = 'Test Puppet code with Puppet code'
  s.description           = 'A Puppet testing framework implemented in the native DSL'
  s.authors               = ['Jordan Olshevski']
  s.email                 = ['jordan@puppetlabs.com']
  s.files                 = Dir.glob('lib/**/*')

  s.add_runtime_dependency 'puppet', ENV['PUPPET_VERSION']

  s.add_development_dependency 'rspec', '3.3.0'
  s.add_development_dependency 'rake', '10.4.2'
  s.add_development_dependency 'puppetlabs_spec_helper', '0.10.3'
  s.add_development_dependency 'mocha', '1.1.0'
end
