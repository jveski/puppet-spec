require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/application/spec'

describe Puppet::Application::Spec do
  describe ".process_spec_directory" do
    context "when no specs are found" do
      before do
        Dir.stubs(:glob).returns([])
      end

      it "should print the expected output" do
        STDOUT.expects(:write).once.with("\n\n")
        STDOUT.expects(:write).once.with("\e[0;33mEvaluated 0 assertions\n\e[0m")
        subject.run_command
      end
    end
  end
end
