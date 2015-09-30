Puppet::Parser::Functions.newfunction(:fixture, :arity => 1, :type => :rvalue) do |values|
  modulepath = compiler.environment.full_modulepath[0]
  file = Dir.glob("#{modulepath}/*/spec/fixtures/#{values[0]}")[0]

  return File.read(file)
end
