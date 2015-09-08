require 'puppet/provider/assertion/evaluator'

describe Puppet::Type.type(:assertion).provider(:evaluator) do
  let(:the_actual) { :stub_actual }

  let(:the_subject) do
    res = Puppet::Resource.new(:stub_type, :stub_title)
    res.file = '/test/directory/manifests/stub_namespace/stub_file.pp'
    res[:stub_attribute] = the_actual
    res
  end

  subject do
    Puppet::Type.type(:assertion).new(
      :name        => :stub_name,
      :subject     => the_subject,
      :attribute   => :stub_attribute,
      :expectation => :stub_expectation,
    ).to_resource.to_ral.provider
  end

  describe ".relative_path" do
    it "should return the path to the subject's manifest after /manifests" do
      expect(subject.relative_path).to eq('stub_namespace/stub_file.pp')
    end
  end

  describe ".wanted" do
    it "should return a hash of the attribute and expected value" do
      expect(subject.wanted).to eq({:stub_attribute => :stub_expectation})
    end
  end

  describe ".got" do
    it "should return a hash of the attribute and subject's actual value" do
      expect(subject.got).to eq({:stub_attribute => :stub_actual})
    end
  end

  describe ".failed?" do
    context "when the subject's attribute is not equal to the expectation" do
      let(:the_actual) { :not_the_stub_expectation }

      it "should return true" do
        expect(subject.failed?).to be true
      end
    end

    context "when the subject's attribute is equal to the expectation" do
      let(:the_actual) { :stub_expectation }

      it "should return false" do
        expect(subject.failed?).to be false
      end
    end
  end

end
