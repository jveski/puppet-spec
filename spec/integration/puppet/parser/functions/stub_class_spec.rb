require 'puppetlabs_spec_helper/module_spec_helper'

describe "the stub_class function" do
  let(:the_node)     { Puppet::Node.new('stub_node') }
  let(:the_compiler) { Puppet::Parser::Compiler.new(the_node) }
  let(:the_scope)    { Puppet::Parser::Scope.new(the_compiler) }

  it "should append a hostclass to the known resource types" do
    the_scope.function_stub_class(["stub class name"])

    expect(
      the_scope.environment.known_resource_types.hostclass("stub class name").name
    ).to eq("stub class name")
  end

end
