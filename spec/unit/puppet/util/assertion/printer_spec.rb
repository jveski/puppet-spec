require 'puppet/util/assertion/printer'

describe Puppet::Util::Assertion::Printer do
  describe "initialization" do
    it "should set the stack to an empty array" do
      expect(subject.stack).to eq([])
    end
  end

  describe "the style methods" do
    let(:the_stack) { stub(:<< => nil) }

    before do
      subject.stubs(:stack).returns(the_stack)
    end

    describe ".red" do
      it "should colorize the msg and append it to the stack" do
        subject.expects(:colorize).with(:red, :stub_message).returns(:stub_colorized_string)
        the_stack.expects(:<<).with(:stub_colorized_string)
        subject.red(:stub_message)
      end
    end

    describe ".blue" do
      it "should colorize the msg and append it to the stack" do
        subject.expects(:colorize).with(:blue, :stub_message).returns(:stub_colorized_string)
        the_stack.expects(:<<).with(:stub_colorized_string)
        subject.blue(:stub_message)
      end
    end

    describe ".yellow" do
      it "should colorize the msg and append it to the stack" do
        subject.expects(:colorize).with(:yellow, :stub_message).returns(:stub_colorized_string)
        the_stack.expects(:<<).with(:stub_colorized_string)
        subject.yellow(:stub_message)
      end
    end

    describe ".white" do
      it "should append the message to the stack" do
        the_stack.expects(:<<).with(:stub_message)
        subject.white(:stub_message)
      end
    end

    describe ".newline" do
      it "should append a newline to the stack" do
        the_stack.expects(:<<).with("\n")
        subject.newline
      end
    end

    describe ".to_s" do
      it "should return the stack as a string" do
        the_stack.expects(:join).returns(:stub_stack)
        expect(subject.to_s).to eq(:stub_stack)
      end
    end
  end
end

describe Puppet::Util::Assertion::Printer::Styler do
  subject do
    class StubClass; include Puppet::Util::Assertion::Printer::Styler; end
    StubClass.new
  end

  describe ".style" do
    let(:the_printer) { stub(:to_s => :stub_output, :instance_eval => nil) }

    before do
      Puppet::Util::Assertion::Printer.stubs(:new).returns(the_printer)
    end

    it "should instantiate a printer" do
      Puppet::Util::Assertion::Printer.expects(:new).returns(the_printer)
      subject.style
    end

    it "should evaluate the proc on the printer" do
      the_printer.expects(:instance_eval)
      subject.style
    end

    it "should return the printer's string" do
      expect(subject.style).to eq(:stub_output)
    end
  end
end
