require 'puppetlabs_spec_helper/module_spec_helper'

describe "the stub_class function" do
  let(:the_node)     { Puppet::Node.new('stub_node') }
  let(:the_compiler) { Puppet::Parser::Compiler.new(the_node) }
  let(:the_scope)    { Puppet::Parser::Scope.new(the_compiler) }
  let(:the_environment) { stub(:name => nil, :known_resource_types => the_resource_types) }
  let(:the_resource_types) { stub(:<< => nil) }

  before do
    the_compiler.stubs(:environment).returns(the_environment)
    Puppet::Resource::Type.stubs(:new).returns(:stub_type)
  end

  context "when given a hash" do
    it "should raise an error" do
      expect{the_scope.function_stub_class([{}])}.to raise_error(
        'stub_class accepts a class name in the form of a string'
      )
    end
  end

  context "when given string" do
    it "should instantiate a hostclass" do
      Puppet::Resource::Type.expects(:new).with(:hostclass, "stub class name")
      the_scope.function_stub_class(["stub class name"])
    end

    it "should append the hostclass to the environment's known resource types" do
      the_resource_types.expects(:<<).with(:stub_type)
      the_scope.function_stub_class(["stub class name"])
    end
  end

end
