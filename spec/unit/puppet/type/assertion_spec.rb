require 'puppetlabs_spec_helper/module_spec_helper'

describe Puppet::Type.type(:assertion) do

  subject do
    Puppet::Type.type(:assertion).new(
      :name => 'the assertion',
    )
  end

  describe ".retrieve" do
    before do
      subject.stubs(:parameters).returns(the_parameters)
    end

    let(:the_parameters) {{
      :stub_1 => stub(:retrieve => nil),
      :stub_2 => stub(:retrieve => nil),
    }}

    it "should retrieve each parameter" do
      the_parameters[:stub_1].expects(:retrieve)
      the_parameters[:stub_2].expects(:retrieve)
      subject.retrieve
    end

    context "when given a param that does not respond to .retrieve" do
      let(:the_parameters) {{
        :stub_1 => stub(:retrieve => nil),
        :stub_2 => stub(:respond_to? => false),
      }}

      it "should not retrieve the parameter" do
        the_parameters[:stub_1].expects(:retrieve)
        the_parameters[:stub_2].expects(:retrieve).never
        subject.retrieve
      end
    end
  end

  describe "#validattr?" do
    context "when given :ensure" do
      it "should return false" do
        expect(subject.class.validattr?(:ensure)).to eq(false)
      end
    end
  end

end
