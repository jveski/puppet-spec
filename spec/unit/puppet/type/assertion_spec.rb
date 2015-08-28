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
