Puppet::Parser::Functions.newfunction(:stub_class, :arity => 1) do |values|

  raise Puppet::Error, "stub_class accepts a class name in the form of a string" unless values[0].is_a?(String)

  compiler.environment.known_resource_types << Puppet::Resource::Type.new(:hostclass, values[0])

end
