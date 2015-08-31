# puppet-spec

Test Puppet code with Puppet code.

## Do I really need to test my Puppet code?
Yes! Testing your Puppet code base will allow you to refactor without wanting to stab out your own eyeballs, and generally fosters a spirit of confidence around making changes. If you haven't written tests before, you may want to become familiar with some basic terminology and best practices before diving in. That said, this tool is intended to provide a low barrier to entry for those new to testing, and should be idiomatic for anyone familiar with the Puppet DSL.

## Getting Started
### Installation
Puppet spec is distributed as a simple Puppet module, and is invoked by running `puppet spec`. You can install the module by cloning this repository into your modulepath, or by running `puppet module install jordan/spec`

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

### Your first test case
```puppet
file { '/tmp/test':
  ensure  => present,
  content => 'The file content',
}

assertion { 'the file has the correct contents':
  subject     => File['/tmp/test'],
  attribute   => 'content',
  expectation => 'The file content',
}

assertion { 'the file is present':
  subject     => File['/tmp/test'],
  attribute   => 'ensure',
  expectation => 'present',
}
```

Wait, what?

Okay, let's break down the attributes of the assertion resource type.

#### Title
The assertion's title should reflect what it is attempting to prove. This value will not used during evaluation, and will only be displayed if the assertion fails.

#### Subject
This attribute's value should be a reference to the resource under question. i.e. `File['the title']` Like the ordering metaparams, etc.

#### Attribute
Attribute determines which attribute of the subject we are asserting on.

#### Expectation
Expectation should be set to the expected value of the subject's attribute as determined by the `subject` and `attribute` params. It's required if attribute is provided.


Okay. Puppet spec test cases are just manifests that happen to contain assertion resources. A typical testcase is essentially an example (declaration test) with assertions. These assertions prove that the resources that have been included in the catalog are in fact what we intended. The tests tend to look something like the below.
```puppet
include apache

assertion { 'the apache::ssl class is in the catalog':
  subject     => Class['apache::ssl'],
}

assertion { 'the apache package version is correct':
  subject     => Package['apache::package'],
  attribute   => 'ensure',
  expectation => '1.2.3',
}
...
```

Any spec manifests stored in the module-under-test's `spec` directory with a `*_spec.pp` suffix will be evaluated when `puppet spec` is executed. Failed assertions are printed to the console rspec style.


## Stubbing
In order to effectively unit test a class, we may need to stub certain dependencies and/or potential side affects. Puppet spec provides three functions that can be used to stub at the Puppet compiler's top scope. Naturally, test cases are parsed top down, so the stub functions must be called before any affected resources are evaluated.

### stub_facts({})
Stub_facts takes a hash of fact/value pairs, and... stubs them. Technically it just defines top scope variables, but stub_top_scope_variables() doesn't quite roll off the tongue.

### stub_class('')
Stub_class stubs a given class. It will accept no params (it's on the way, PR maybe?), and contains no resources. Classes can be namespaced as expected with the scope indicator.

### stub_type('')
Stub_type stubs a defined type. Any parameters will be accepted and can be asserted upon. Like the stub_class function, the type name can be namespaced as you would expect.


## What should I test?
Everything!

### Component Modules
Concentrate on unit tests for resources that receive attribute values from logical expressions or user input, since there are more moving parts and thus, risk. That said, you want to cover every attribute of each resource whenever possible.

Beyond the unit tests, integration tests on high level or entrypoint classes will make future refactoring less painful.

### Roles/profiles
This is where things get cool. There can be a certain amount of discomfort around proper use of abstraction in Puppet code, since it obscures exactly what resources are included for a given node. By integration testing the node's profile, we can be absolutely certain of which resources will end up in the catalog at any given point in time. I've seen this calm the nerves of even the most paranoid sysadmin.

In this climate, we can freely make changes to the underlying component modules without worrying about undesirable side effects.

## Want to pitch in?
I wrote this tool because I felt that the community could use an approachable testing mechanism in Puppet's native tongue. If you feel the same, feel free to contribute bug fixes or features. If your changes have good tests (irony?), I'll merge and not yell at you even a little bit. If you're not up for the hacking, feel free to open an issue and I'll have a look.

### Roadmap
  * Regex expectations (for long file content and whatnot)
  * Better type/function documentation (read: type/function documentation)
  * CLI option for specifying single spec
  * Allow stubbed classes to receive arbitrary parameters and receive assertions

### Development Workflow
  * `bundle install`
  * `bundle exec rake spec`
  * `bundle exec rake acceptance`
  * change things
  * `bundle exec rake spec`
  * `bundle exec rake acceptance`
  * etc.
