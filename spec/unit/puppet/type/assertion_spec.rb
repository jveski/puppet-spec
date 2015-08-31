require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/type/assertion'

describe Puppet::Type::Assertion::ParameterAttribute do
  let(:the_resource) { stub }
  let(:the_subject) { stub }
  subject { Puppet::Type::Assertion::ParameterAttribute.new(:resource => the_resource) }

  describe ".validate" do
    before do
      the_resource.stubs(:[]).returns(the_subject)
    end

    context "when not given a value" do
      it "should raise an error" do
        expect{subject.validate(nil)}.to raise_error(
          'You must provide attribute to be asserted'
        )
      end
    end

    context "when given a valid parameter" do
      let(:the_subject) { stub(:valid_parameter? => true) }
      it "should not raise an error" do
        expect{subject.validate('stub attribute')}.to_not raise_error
      end
    end

  end
end

describe Puppet::Type::Assertion::ParameterSubject do
  let(:the_resource) { stub }
  subject { Puppet::Type::Assertion::ParameterSubject.new(:resource => the_resource) }

  describe ".validate" do
    context "when not given a value" do
      it "should raise an error" do
        expect{subject.validate(nil)}.to raise_error(
          'You must provide an assertion subject'
        )
      end
    end

    context "when given a string" do
      it "should raise an error" do
        expect{subject.validate('test')}.to raise_error(
          'Attributes must be a resource reference'
        )
      end
    end

    context "when given a Puppet resource" do
      let(:the_resource) do
        Puppet::Type.type(:package).new(
          :name => 'the resource',
        ).to_resource
      end

      it "should should not raise an error" do
        expect{subject.validate(the_resource)}.to_not raise_error
      end
    end
  end
end
