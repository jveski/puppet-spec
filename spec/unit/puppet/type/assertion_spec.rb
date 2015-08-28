require 'puppet/type/assertion'

describe Puppet::Type.type(:assertion) do

  subject do
    Puppet::Type.type(:assertion).new(
      :name => 'the assertion',
    )
  end

  describe "#validattr?" do
    context "when given :ensure" do
      it "should return false" do
        expect(subject.class.validattr?(:ensure)).to eq(false)
      end
    end
  end

end

describe Puppet::Parameter::Assertable do
  let(:the_resource) do
    Puppet::Type.type(:assertion).new(
      :name => :stub_name,
      :test => :stub_test_value,
    )
  end
  subject { the_resource[:test] }

  describe ".munge" do
    it "should return its instance" do
      expect(subject.munge(:stub_value)).to be(subject)
    end

    it "should set the input value" do
      expect(subject.munge(:stub_value).input).to eq(:stub_value)
    end
  end

  describe ".assert!" do
    let(:the_reference) { double(:[] => :stub_obj) }

    context "when given a reference with a non-matching value" do
      let(:the_reference) { double(:[] => :nope) }

      it "should mark the assertion as failed" do
        inst = subject.assert!(the_reference)
        expect(subject.assertion_status).to eq(:failed)
      end
    end

    context "when given a reference with a matching value" do
      let(:the_reference) { double(:[] => :stub_test_value) }

      it "should mark the assertion as passed" do
        inst = subject.assert!(the_reference)
        expect(subject.assertion_status).to eq(:passed)
      end
    end

    it "should set the reference" do
      inst = subject.assert!(the_reference)
      expect(subject.reference).to eq(the_reference)
    end

    context "when it has already been invoked" do
      before { allow(subject).to receive(:assertion_status).and_return(true) }
      it "should raise an error" do
        expect{subject.assert!(the_resource)}.to raise_error(
          'Cannot be asserted upon multiple times'
        )
      end
    end
  end

end
