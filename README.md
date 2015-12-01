# puppet-spec
[![Build Status](https://travis-ci.org/jolshevski/puppet-spec.svg?branch=master)](https://travis-ci.org/jolshevski/puppet-spec)

Test Puppet code with Puppet code.

## Why not rspec-puppet?
Puppet-spec is intended to provide a low barrier to entry for those new to testing, and is idiomatic for anyone familiar with the Puppet DSL. Rspec-puppet, while more powerful, is far more complex and requires past exposure to Ruby and rspec. Don't think of puppet-spec as an attempt to undermine the wide adoption of rspec-puppet in the community, but rather the fulfilment of an unmet, yet significant need.

## Getting Started
### Installation
#### Puppet Module
You can install the Puppet spec module by cloning this repository into your modulepath, or by running `puppet module install jordan/spec`. The `puppet spec` command will be available once the module has been installed.

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
The assertion's title should reflect what it is attempting to prove. This value will not used during evaluation, and serves only to provide insight to the user in the event that the assertion fails.

##### Subject
A resource reference to the resource under test, i.e. `File['/etc/puppetlabs/puppet/puppet.conf']`.

##### Attribute
If the attribute parameter is not provided, the assertion will prove only the presence of the subject resource in the catalog.
Otherwise, attribute can be used to select which attribute of the subject resource the assertion will set an expectation on.

##### Expectation
Expectation should be set to the expected value of the subject's attribute as determined by the `subject` and `attribute` params. It's required if attribute is provided.

##### Ensure
Defaults to 'present', and accepts values 'present' and 'absent'. If the ensure attribute is set to absent, the assertion will validate that the subject is absent from the catalog. Expectation and attribute cannot be set in conjunction with ensure => 'absent'.


Puppet spec test cases are just manifests that contain assertion resource declarations. A typical test case is essentially an example (smoke test) with assertions.
The assertions prove that the referenced resources have been included in the catalog and have the expected attributes. Test cases tend to look something like the below.
```puppet
include apache

assertion { 'that the apache::ssl class is in the catalog':
  subject => Class['apache::ssl'],
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


## Fixtures
Asserting on attributes with a long value can cause test suites to become unmanageably large, so Puppet spec provides a `fixture` function which reads from a given file underneath `spec/fixtures`.

### Example
```puppet
assertion { 'that the file has the correct very long contents':
  subject     => File['/tmp/largefile'],
  attribute   => 'content',
  expectation => fixture('file_contents'), #This would load the file `<module>/spec/fixtures/file_contents`
}
```

## Negative Assertions
Considering that Puppet modules often make use of logical expressions to exclude resources from the catalog, Puppet spec's assertion resource type has an ensure attribute, which when given the value `absent`, sets an expectation on the absence of a resource from the catalog.

```puppet
assertion { 'that the undesired file is not in the catalog':
  ensure  => absent,
  subject => File['/tmp/should/not/be/around'],
}
```

## Want to pitch in?
I wrote this tool because I felt that the community could use an approachable testing mechanism in Puppet's native tongue. If you feel the same, feel free to take on an open GH issue, or find a bug.
