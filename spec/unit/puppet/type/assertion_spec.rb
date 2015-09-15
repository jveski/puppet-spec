require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/type/assertion'

describe Puppet::Type.type(:assertion) do
  describe "validate" do
    context "when given a attribute, expectation, and subject" do
      subject do
        Puppet::Type.type(:assertion).new(
          :name        => :stub_name,
          :attribute   => :stub_attribute,
          :expectation => :stub_expectation,
          :subject     => Puppet::Resource.new(:stub_type, :stub_subject),
        )
      end

      it "should not raise an error" do
        expect{subject.validate}.to_not raise_error
      end
    end

    context "when given a attribute and expectation" do
      subject do
        Puppet::Type.type(:assertion).new(
          :name        => :stub_name,
          :attribute   => :stub_attribute,
          :expectation => :stub_expectation,
        )
      end

      it "should raise an error" do
        expect{subject.validate}.to raise_error(
          'Validation of Assertion[stub_name] failed: a subject is required'
        )
      end
    end

    context "when given an attribute and no expectation" do
      subject do
        Puppet::Type.type(:assertion).new(
          :name        => :stub_name,
          :attribute   => :stub_attribute,
          :subject     => Puppet::Resource.new(:stub_type, :stub_subject),
        )
      end

      it "should raise an error" do
        expect{subject.validate}.to raise_error(
          'Validation of Assertion[stub_name] failed: an expectation is required when an attribute is given'
        )
      end
    end

    context "when given an expectation and no attribute" do
      subject do
        Puppet::Type.type(:assertion).new(
          :name        => :stub_name,
          :expectation => :stub_expectation,
          :subject     => Puppet::Resource.new(:stub_type, :stub_subject),
        )
      end

      it "should raise an error" do
        expect{subject.validate}.to raise_error(
          'Validation of Assertion[stub_name] failed: an attribute is required when an expectation is given'
        )
      end
    end
  end
end

describe Puppet::Type::Assertion::ParameterEnsure do
  let(:the_resource) { stub }
  subject { Puppet::Type::Assertion::ParameterEnsure.new(:resource => the_resource) }

  describe ".retrieve" do
    it "should respond" do
      expect(subject).to respond_to(:retrieve)
    end
  end

  describe ".validate" do
    context "when given foobar" do
      it "should raise an error" do
        expect{subject.validate("foobar")}.to raise_error(
          "Ensure only accepts values 'present' or 'absent'"
        )
      end
    end

    context "when given absent" do
      it "should should not raise an error" do
        expect{subject.validate("absent")}.to_not raise_error
      end
    end

    context "when given present" do
      it "should should not raise an error" do
        expect{subject.validate("present")}.to_not raise_error
      end
    end
  end
end
