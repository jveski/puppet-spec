require 'puppetlabs_spec_helper/module_spec_helper'

describe "the stub_fact function" do
  let(:the_node)     { Puppet::Node.new('stub_node') }
  let(:the_compiler) { Puppet::Parser::Compiler.new(the_node) }
  let(:the_scope)    { Puppet::Parser::Scope.new(the_compiler) }
  let(:the_topscope) { stub(:[]= => nil) }

  before do
    the_compiler.stubs(:topscope).returns(the_topscope)
  end

  context "when given a string" do
    it "should raise an error" do
      expect{the_scope.function_stub_facts(["stub string"])}.to raise_error(
        'stub_facts accepts a hash of fact/value pairs'
      )
    end
  end

  context "when given a hash of fact/value pairs" do
    let(:the_facts) {{
      'stubfact1' => 'stubvalue1',
      'stubfact2' => 'stubvalue2',
    }}

    it "should set each value" do
      the_topscope.expects(:[]=).once.with('stubfact1', 'stubvalue1')
      the_topscope.expects(:[]=).once.with('stubfact2', 'stubvalue2')
      the_scope.function_stub_facts([the_facts])
    end
  end

end
