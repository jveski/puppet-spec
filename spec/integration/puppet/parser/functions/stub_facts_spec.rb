require 'puppetlabs_spec_helper/module_spec_helper'

describe "the stub_facts function" do
  let(:the_node)     { Puppet::Node.new('stub_node') }
  let(:the_compiler) { Puppet::Parser::Compiler.new(the_node) }
  let(:the_scope)    { Puppet::Parser::Scope.new(the_compiler) }

  it "should assign each topscope variable" do
    the_scope.function_stub_facts([{
      'osfamily'  => 'not a real os',
      'ipaddress' => 'not a real ip',
    }])

    expect(the_compiler.topscope['osfamily']).to eq('not a real os')
    expect(the_compiler.topscope['ipaddress']).to eq('not a real ip')
  end

end
