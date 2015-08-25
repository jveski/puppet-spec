require 'puppetlabs_spec_helper/module_spec_helper'

describe Puppet::Type.type(:assertion).provider(:resource) do
  let(:the_resource) do
    Puppet::Type.type(:assertion).new(
      :name     => 'the test assertion',
      :provider => :resource,
      :subject  => the_assertion_subject,
      :stub_key => :stub_value,
    )
  end
  let(:the_assertion_subject) { stub('assertion_subject',
                                     :class => the_type,
                                     :to_s  => :stub_title,
                                     :[]    => :stub_value,
                                    ) }
  let(:the_type) { stub('type') }
  subject { the_resource.provider }

  context "when the referenced resource does not support the given parameter" do
    before do
      the_type.stubs(:valid_parameter?).returns(false)
    end
    it "should raise an error" do
      expect { subject.assert(:stub_key) }.to raise_error(
        "Cannot make an assertion on the value of parameter 'stub_key' because the resource stub_title does not support it."
      )
    end
  end

  context "when the referenced resource does support the given parameter" do
    before do
      the_type.stubs(:valid_parameter?).returns(true)
    end
    it "should not raise an error" do
      expect { subject.assert(:stub_key) }.to_not raise_error
    end

    context "when the referenced resource does not have the correct value" do
      before do
        the_assertion_subject.stubs(:[]).returns(:not_value)
      end
      it "should raise an error" do
        expect { subject.assert(:stub_key) }.to raise_error(
          "Assertion failed on parameter stub_key. Wanted value 'stub_value' got 'not_value'"
        )
      end
    end

    context "when the referenced resource does have the correct value" do
      before do
        the_assertion_subject.stubs(:[]).returns(:stub_value)
      end
      it "should not raise an error" do
        expect { subject.assert(:stub_key) }.to_not raise_error
      end
    end
  end

end
