Puppet::Parser::Functions.newfunction(:stub_facts, :arity => 1) do |values|

  raise Puppet::Error, "stub_facts accepts a hash of fact/value pairs" unless values[0].is_a?(Hash)

  values[0].each do |key, value|
    self.compiler.topscope[key] = value
  end

end
