require 'puppet/type/assertion'

describe Puppet::Type::Assertion::ParameterAttributes do
  let(:the_resource) { double }
  subject { Puppet::Type::Assertion::ParameterAttributes.new(:resource => the_resource) }

  describe ".validate" do
    context "when not given a value" do
      it "should raise an error" do
        expect{subject.validate(nil)}.to raise_error(
          'You must provide attributes to be asserted'
        )
      end
    end

    context "when given a string" do
      it "should raise an error" do
        expect{subject.validate('test')}.to raise_error(
          'Attributes must be a hash'
        )
      end
    end

    context "when given a hash" do
      it "should should not raise an error" do
        expect{subject.validate({})}.to_not raise_error
      end
    end
  end
end

describe Puppet::Type::Assertion::ParameterSubject do
  let(:the_resource) { double }
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
