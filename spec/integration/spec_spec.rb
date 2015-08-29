require 'puppet/application/spec'

describe Puppet::Application::Spec do

  describe ".run_command" do
    before do
      allow(Puppet::Test::TestHelper).to receive(:initialize)
      allow(subject).to receive(:process_spec_directory)
      allow(subject).to receive(:print)
      allow(subject).to receive(:exit)
      allow(subject).to receive(:specdir).and_return(:stub_specdir)
    end

    it "should initialize Puppet" do
      subject.run_command
      expect(Puppet::Test::TestHelper).to have_received(:initialize)
    end

    it "should process the spec directory" do
      subject.run_command
      expect(subject).to have_received(:process_spec_directory).with(:stub_specdir)
    end

    context "when an error is not raised" do
      it "should not print to the console" do
        subject.run_command
        expect(subject).to_not have_received(:print)
      end

      it "should not exit" do
        subject.run_command
        expect(subject).to_not have_received(:exit)
      end
    end

    context "when an error is raised" do
      let(:the_error) { Exception.new('stub exception') }
      before { allow(subject).to receive(:process_spec_directory).and_raise(the_error) }

      it "should print it to the console" do
        subject.run_command
        expect(subject).to have_received(:print).with("\e[0;31mstub exception\n\e[0m")
      end

      it "should exit 1" do
        subject.run_command
        expect(subject).to have_received(:exit).with(1)
      end
    end
  end

  describe ".notify_compiled" do
    before do
      allow(subject).to receive(:print)
    end

    it "should print a green period" do
      subject.notify_compiled
      expect(subject).to have_received(:print).with("\e[0;32m.\e[0m")
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
