require 'puppet/util/assertion/stubs'

describe Puppet::Util::Assertion::Stubs::Type do
  subject { Puppet::Util::Assertion::Stubs::Type.new(:definition, 'stub resource') }

  describe ".valid_parameter?" do
    it "should return true" do
      expect(subject.valid_parameter?('anything')).to be true
    end
  end

end
