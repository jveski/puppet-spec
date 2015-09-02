require 'puppetlabs_spec_helper/module_spec_helper'

describe "the stub_type function" do
  let(:the_node)     { Puppet::Node.new('stub_node') }
  let(:the_compiler) { Puppet::Parser::Compiler.new(the_node) }
  let(:the_scope)    { Puppet::Parser::Scope.new(the_compiler) }

  it "should append a stub resource to the known resource types" do
    the_scope.function_stub_type(["stub type name"])

    expect(
      the_scope.environment.known_resource_types.definition("stub type name").name
    ).to eq("stub type name")
  end

end
