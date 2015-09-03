require 'puppet/util/stubs'

describe Puppet::Util::Stubs::Type do
  subject { Puppet::Util::Stubs::Type.new(:definition, 'stub resource') }

  describe ".valid_parameter?" do
    it "should return true" do
      expect(subject.valid_parameter?('anything')).to be true
    end
  end

end
