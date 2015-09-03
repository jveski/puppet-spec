require 'puppet/util/stubs'

Puppet::Parser::Functions.newfunction(:stub_type, :arity => 1) do |values|

  raise Puppet::Error, "stub_type accepts a type name in the form of a string" unless values[0].is_a?(String)

  compiler.environment.known_resource_types << Puppet::Util::Stubs::Type.new(:definition, values[0])

end
