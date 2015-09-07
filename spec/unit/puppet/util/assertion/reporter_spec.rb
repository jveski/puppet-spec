require 'puppet/util/assertion/reporter'

describe Puppet::Util::Assertion::Reporter do

  describe "the initialization" do
    it "should set the evaluated count to 0" do
      expect(subject.evaluated).to eq(0)
    end

    it "should set the failed count to 0" do
      expect(subject.failed).to eq(0)
    end
  end

  describe ".<<" do
    let(:the_resource) { stub(:provider => the_provider) }

    before do
      subject.stubs(:count)
      subject.stubs(:fail)
      subject.stubs(:report)
    end

    context "when given a true assertion" do
      let(:the_provider) { stub(:failed? => false) }

      it "should evaluate the assertion" do
        the_provider.expects(:failed?)
        subject << the_resource
      end

      it "should increment the assertion counter" do
        subject.expects(:count)
        subject << the_resource
      end

      it "should not increment the failed counter" do
        subject.expects(:fail).never
        subject << the_resource
      end

      it "should not print the assertion" do
        subject.expects(:report).never
        subject << the_resource
      end
    end

    context "when given a false assertion" do
      let(:the_provider) { stub(:failed? => true) }

      it "should evaluate the assertion" do
        the_provider.expects(:failed?)
        subject << the_resource
      end

      it "should increment the assertion counter" do
        subject.expects(:count)
        subject << the_resource
      end

      it "should increment the failed counter" do
        subject.expects(:fail)
        subject << the_resource
      end

      it "should print the assertion" do
        subject.expects(:report).with(the_resource)
        subject << the_resource
      end
    end
  end

  describe ".print_footer" do
    it "should print the stylized footer" do
      subject.expects(:style)
      subject.print_footer
    end
  end

  describe ".print_error" do
    let(:the_error) { stub(:message => :stub_message) }

    before do
      subject.stubs(:style)
      subject.stubs(:fail)
    end

    it "should mark a failed assertion" do
      subject.expects(:fail)
      subject.print_error(the_error)
    end

    it "should print the error" do
      subject.expects(:style)
      subject.print_error(the_error)
    end
  end

  describe ".report" do
    it "should print the stylized assertion results" do
      subject.expects(:style)
      subject.report(:stub_resource)
    end
  end

  describe ".count" do
    it "should increment evaluated" do
      subject.count
      subject.count
      expect(subject.evaluated).to eq(2)
    end
  end

  describe ".fail" do
    it "should increment failed" do
      subject.fail
      subject.fail
      expect(subject.failed).to eq(2)
    end
  end

end
