require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/parser/functions/stub_type'

describe "the stub_type function" do
  let(:the_node)     { Puppet::Node.new('stub_node') }
  let(:the_compiler) { Puppet::Parser::Compiler.new(the_node) }
  let(:the_scope)    { Puppet::Parser::Scope.new(the_compiler) }
  let(:the_environment) { stub(:name => nil, :known_resource_types => the_resource_types) }
  let(:the_resource_types) { stub(:<< => nil) }

  before do
    the_compiler.stubs(:environment).returns(the_environment)
    Puppet::Resource::Type::Stub.stubs(:new).returns(:stub_type)
  end

  context "when given a hash" do
    it "should raise an error" do
      expect{the_scope.function_stub_type([{}])}.to raise_error(
        'stub_type accepts a type name in the form of a string'
      )
    end
  end

  context "when given string" do
    it "should instantiate a stub type" do
      Puppet::Resource::Type::Stub.expects(:new).with(:definition, "stub type name")
      the_scope.function_stub_type(["stub type name"])
    end

    it "should append the type stub to the environment's known resource types" do
      the_resource_types.expects(:<<).with(:stub_type)
      the_scope.function_stub_type(["stub class name"])
    end
  end

end
