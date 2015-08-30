class Puppet::Resource::Type::Stub < Puppet::Resource::Type
  # Allow the stub type to receive
  # assignments on any parameter key.
  def valid_parameter?(name)
    true
  end
end

Puppet::Parser::Functions.newfunction(:stub_type, :arity => 1) do |values|

  raise Puppet::Error, "stub_type accepts a type name in the form of a string" unless values[0].is_a?(String)

  compiler.environment.known_resource_types << Puppet::Resource::Type::Stub.new(:definition, values[0])

end
