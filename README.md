# puppet-spec
[![Build Status](https://travis-ci.org/jolshevski/puppet-spec.svg?branch=master)](https://travis-ci.org/jolshevski/puppet-spec)

Test Puppet code with Puppet code.

## Why not rspec-puppet?
Puppet-spec is intended to provide a low barrier to entry for those new to testing, and is idiomatic for anyone familiar with the Puppet DSL. Rspec-puppet, while more powerful, is far more complex and requires past exposure to Ruby and rspec. Don't think of puppet-spec as an attempt to undermine the wide adoption of rspec-puppet in the community, but rather the fulfilment of an unmet, yet significant need.

## Getting Started
### Installation
#### Puppet Module
You can install the Puppet spec module by cloning this repository into your modulepath, or by running `puppet module install jordan/spec`. Once the module is in your modulepath, the Puppet application `puppet spec` will be available.

#### Rubygem
If your Puppet module has a Gemfile, you can add the gem `puppet-spec` as a dependency and include the bundled rake task to simplify the process of invoking your test suite.
Just add `require puppet-spec/tasks` to your Rakefile, and run `rake puppetspec` to invoke the test suite.

### Requirements
Puppet spec is tested on all permutations of the below versions.

Puppet:
  * 4.2.1
  * 4.2.0
  * 4.1.0
  * 4.0.0

Ruby:
  * 2.2.0
  * 2.1.0
  * 2.0.0
  * 1.9.3

### A simple test case
```puppet
file { '/tmp/test':
  ensure  => present,
  content => 'The file content',
}

assertion { 'that the file has the correct contents':
  subject     => File['/tmp/test'],
  attribute   => 'content',
  expectation => 'The file content',
}

assertion { 'that the file is present':
  subject     => File['/tmp/test'],
  attribute   => 'ensure',
  expectation => 'present',
}
```

#### The Assertion Resource Type
##### Title
The assertion's title should reflect what it is attempting to prove. This value will not used during evaluation, and will only be displayed if the assertion fails.

##### Subject
This attribute's value should be a reference to the resource under question. i.e. `File['the title']` Like the ordering metaparams, etc.

##### Attribute
Attribute determines which attribute of the subject we are asserting on.

##### Expectation
Expectation should be set to the expected value of the subject's attribute as determined by the `subject` and `attribute` params. It's required if attribute is provided.

##### Ensure
Defaults to 'present', and accepts values 'present' and 'absent'. If the ensure attribute is set to absent, the assertion will validate that the subject is absent from the catalog. Expectation and attribute cannot be set in conjunction with ensure => 'absent'.


Puppet spec test cases are just manifests that happen to contain assertion resources. A typical testcase is essentially an example (declaration test) with assertions. These assertions prove that the resources that have been included in the catalog are in fact what we intended. The tests tend to look something like the below.
```puppet
include apache

assertion { 'that the apache::ssl class is in the catalog':
  subject     => Class['apache::ssl'],
}

assertion { 'that the apache package version is correct':
  subject     => Package['apache::package'],
  attribute   => 'ensure',
  expectation => '1.2.3',
}
...
```

Any spec manifests stored in the module-under-test's `spec` directory with a `*_spec.pp` suffix will be evaluated when `puppet spec` is executed. Failed assertions are printed to the console rspec style.


## Stubbing
In order to effectively unit test a class, we may need to stub certain dependencies and/or potential side affects. Puppet spec provides three functions that can be used to stub at the Puppet compiler's top scope. Naturally, test cases are parsed top down, so the stub functions must be called before any affected resources are evaluated.

For examples, check out the acceptance test suite.

#### stub_facts({})
Stub_facts takes a hash of fact/value pairs, and... stubs them. Technically it just defines top scope variables, but stub_top_scope_variables() doesn't quite roll off the tongue.

#### stub_class('')
Stub_class stubs a given class. The stubbed class will accept values for any param. Classes can be namespaced as expected with the scope indicator.

#### stub_type('')
Stub_type stubs a defined type. Any parameters will be accepted and can be asserted upon. Like the stub_class function, the type name can be namespaced as you would expect.


## Want to pitch in?
I wrote this tool because I felt that the community could use an approachable testing mechanism in Puppet's native tongue. If you feel the same, feel free to take on an open GH issue, or find a bug. If your changes have good tests (irony?), I'll merge and not yell at you even a little bit. If you're not up for the hacking, feel free to open an issue and I'll have a look.

### Development Workflow
  * `bundle install`
  * `bundle exec rake spec`
  * `bundle exec rake acceptance`
  * change things
  * `bundle exec rake spec`
  * `bundle exec rake acceptance`
  * etc.
