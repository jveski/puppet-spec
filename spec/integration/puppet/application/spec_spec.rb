require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/application/spec'

describe Puppet::Application::Spec do

  describe ".run_command" do
    before do
      Puppet::Test::TestHelper.stubs(:initialize)
      subject.stubs(:process_spec_directory)
      subject.stubs(:print)
      subject.stubs(:exit)
      subject.stubs(:specdir).returns(:stub_specdir)
    end

    it "should initialize Puppet" do
      Puppet::Test::TestHelper.expects(:initialize)
      subject.run_command
    end

    it "should process the spec directory" do
      subject.expects(:process_spec_directory).with(:stub_specdir)
      subject.run_command
    end

    context "when an error is not raised" do
      it "should not print to the console" do
        subject.run_command
        subject.expects(:print).never
      end

      it "should not exit" do
        subject.run_command
        subject.expects(:exit).never
      end
    end

    context "when an error is raised" do
      let(:the_error) { Exception.new('stub exception') }
      before { subject.stubs(:process_spec_directory).raises(the_error) }

      it "should print it to the console" do
        subject.expects(:print).with("\e[0;31mstub exception\n\e[0m")
        subject.run_command
      end

      it "should exit 1" do
        subject.expects(:exit).with(1)
        subject.run_command
      end
    end
  end

  describe ".notify_compiled" do
    before { subject.stubs(:print) }

    it "should print a green period" do
      subject.expects(:print).with("\e[0;32m.\e[0m")
      subject.notify_compiled
    end
  end

  describe ".visit_assertions" do
    context "when given one passing assertion" do
      let(:the_assertions) {[
        {
          :expectation => 'stub_expectation_1',
          :attribute   => 'stub_attribute_1',
          :name        => 'stub_name_1',
          :subject     => {
            'stub_attribute_1' => 'stub_expectation_1',
          },
        }
      ]}
      it "should return the expected output" do
        expect(subject.visit_assertions(the_assertions)).to eq(
          "\e[0;33mEvaluated 1 assertion\n\e[0m"
        )
      end
    end

    context "when given two passing assertions" do
      let(:the_assertions) {[
        {
          :expectation => 'stub_expectation_1',
          :attribute   => 'stub_attribute_1',
          :name        => 'stub_name_1',
          :subject     => {
            'stub_attribute_1' => 'stub_expectation_1',
          },
        },
        {
          :expectation => 'stub_expectation_2',
          :attribute   => 'stub_attribute_2',
          :name        => 'stub_name_2',
          :subject     => {
            'stub_attribute_2' => 'stub_expectation_2',
          },
        }
      ]}
      it "should return the expected output" do
        expect(subject.visit_assertions(the_assertions)).to eq(
          "\e[0;33mEvaluated 2 assertions\n\e[0m"
        )
      end
    end

    context "when given one passing and one failing assertion" do
      let(:the_assertions) {[
        {
          :expectation => 'stub_expectation_1',
          :attribute   => 'stub_attribute_1',
          :name        => 'stub_name_1',
          :subject     => {
            'stub_attribute_1' => 'stub_expectation_1',
          },
        },
        {
          :expectation => 'stub_expectation_2',
          :attribute   => 'stub_attribute_2',
          :name        => 'stub_name_2',
          :subject     => {
            'stub_attribute_2' => 'not the expectation',
          },
        }
      ]}
      it "should return the expected output" do
        expect(subject.visit_assertions(the_assertions)).to eq(
          "\e[0;31m1) Assertion stub_name_2 failed on {\"stub_attribute_2\"=>\"not the expectation\"}\n\e[0m\e[0;34m  Wanted: \e[0mstub_attribute_2 => 'stub_expectation_2'\n\e[0;34m  Got:    \e[0mstub_attribute_2 => 'not the expectation'\n\n\e[0;33mEvaluated 2 assertions\n\e[0m"
        )
      end
    end
  end

end
