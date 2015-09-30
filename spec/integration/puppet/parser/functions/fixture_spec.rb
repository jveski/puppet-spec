require 'puppetlabs_spec_helper/module_spec_helper'

describe "the fixture function" do
  let(:the_node)     { Puppet::Node.new('stub_node') }
  let(:the_compiler) { Puppet::Parser::Compiler.new(the_node) }
  let(:the_scope)    { Puppet::Parser::Scope.new(the_compiler) }

  it "should load the fixture" do
    File.expects(:read).returns(:stub_file)
    expect(the_scope.function_fixture(["the fixture"])).to eq(:stub_file)
  end

end
