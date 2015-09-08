require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/application/spec'

# Test the seam between the application,
# reporter, and styler.
describe Puppet::Application::Spec do
  describe ".run_command" do
    before do
      subject.stubs(:exit)
      STDOUT.stubs(:write)
    end

    context "when an error is not raised" do
      before { subject.stubs(:evaluate_assertions) }
      it "should exit 0" do
        subject.expects(:exit).with(0)
        subject.run_command
      end

      it "should print the expected message to the STDOUT" do
        STDOUT.expects(:write).with("\e[0;33mEvaluated 0 assertions\e[0m\n")
        subject.run_command
      end
    end

    context "when an error is raised" do
      before { subject.stubs(:evaluate_assertions).raises("stub error") }
      it "should exit 1" do
        subject.expects(:exit).with(1)
        subject.run_command
      end

      it "should print the expected message to the STDOUT" do
        STDOUT.expects(:write).with("\e[0;31mstub error\e[0m\n")
        subject.run_command
      end
    end
  end
end
