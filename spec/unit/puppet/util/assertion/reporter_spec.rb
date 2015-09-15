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
    let(:the_provider) { stub(:failed? => false) }
    let(:the_resource) { stub(:provider => the_provider, :[] => nil) }

    before do
      subject.stubs(:count)
      subject.stubs(:fail)
      subject.stubs(:expected_present)
      subject.stubs(:expected_absent)
      subject.stubs(:inequal_value)
    end

    it "should increment the counter" do
      subject.expects(:count)
      subject << the_resource
    end

    context "when the subject is expected to be present but is absent" do
      before do
        the_resource.stubs(:[]).with(:ensure).returns('present')
        the_resource.stubs(:[]).with(:subject).returns(:absent)
      end

      it "should increment the fail counter" do
        subject.expects(:fail).once
        subject << the_resource
      end

      it "should print a message" do
        subject.expects(:expected_present).with(the_resource)
        subject << the_resource
      end
    end

    context "when the subject is expected to be present and is present" do
      before do
        the_resource.stubs(:[]).with(:ensure).returns('present')
        the_resource.stubs(:[]).with(:subject).returns(:stub_resource)
      end

      it "should evaluate the provider for failure" do
        the_provider.expects(:failed?).returns(:stub_results)
        subject << the_resource
      end

      context "if the assertion did not fail" do
        before { the_provider.stubs(:failed?).returns(false) }

        it "should not increment the fail counter" do
          subject.expects(:fail).never
          subject << the_resource
        end

        it "should not print the report" do
          subject.expects(:inequal_value).never
          subject << the_resource
        end
      end

      context "if the assertion failed" do
        before { the_provider.stubs(:failed?).returns(true) }

        it "should increment the fail counter" do
          subject.expects(:fail).once
          subject << the_resource
        end

        it "should print the report" do
          subject.expects(:inequal_value).with(the_resource)
          subject << the_resource
        end
      end
    end

    context "when the resource is expected to be absent and is present" do
      before do
        the_resource.stubs(:[]).with(:ensure).returns('absent')
        the_resource.stubs(:[]).with(:subject).returns(:stub_resource)
      end

      it "should increment the fail counter" do
        subject.expects(:fail).once
        subject << the_resource
      end

      it "should print a message" do
        subject.expects(:expected_absent).with(the_resource)
        subject << the_resource
      end
    end

    context "when the resource is expected to be absent and is absent" do
      before do
        the_resource.stubs(:[]).with(:ensure).returns('absent')
        the_resource.stubs(:[]).with(:subject).returns(:absent)
      end

      it "should not increment the fail counter" do
        subject.expects(:fail).never
        subject << the_resource
      end

      it "should not print a message" do
        subject.expects(:expected_absent).never
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

  describe ".inequal_value" do
    it "should print the stylized assertion results" do
      subject.expects(:style)
      subject.inequal_value(:stub_resource)
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
