require 'puppet/util/assertion/printer'

describe Puppet::Util::Assertion::Printer do
  subject do
    class StubClass; include Puppet::Util::Assertion::Printer::Styler; end
    StubClass.new
  end

  context "given a proc" do
    it "should print the correct string" do
      subject.expects(:print).with("\e[0;31mthe red string\e[0m\n\e[0;34mthe blue string\e[0m\n\e[0;33mthe yellow string\e[0m\nthe white string")

      subject.style do
        red    "the red string"
        newline
        blue   "the blue string"
        newline
        yellow "the yellow string"
        newline
        white  "the white string"
      end
    end
  end

end
