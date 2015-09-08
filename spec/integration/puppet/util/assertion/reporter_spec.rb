require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/util/assertion/reporter'

describe Puppet::Util::Assertion::Reporter do

  # Covers the integration of the assertion resource
  # type/provider with the reporter.
  describe ".<<" do
    before { subject.stubs(:print) }
    context "with a single assertion resource" do
      let(:the_assertion) do
        Puppet::Type.type(:assertion).new(
          :name        => 'stub assertion 1',
          :attribute   => 'stub_attribute',
          :expectation => 'stub_value',
          :subject     => the_subject,
        )
      end

      let(:the_subject) do
        subj = Puppet::Resource.new(:stub_type, :stub_title)
        subj['stub_attribute'] = the_subject_value
        subj.file = 'long/file/path/manifests/stub_namespace/stub_manifest.pp'
        subj.line = '123'
        subj
      end

      context "with a true assertion" do
        let(:the_subject_value) { 'stub_value' }
        
        it "should print the expected output" do
          subject.expects(:print).never
          subject << the_assertion
        end
      end

      context "with a false assertion" do
        let(:the_subject_value) { 'stub_incorrect_value' }

        it "should print the expected output" do
          subject.expects(:print).with(
            "\e[0;31m1) Assertion stub assertion 1 failed on Stub_type[stub_title]\e[0m\n\e[0;33m  On line 123 of stub_namespace/stub_manifest.pp\e[0m\n\e[0;34m  Wanted: \e[0m{\"stub_attribute\"=>\"stub_value\"}\n\e[0;34m  Got:    \e[0m{\"stub_attribute\"=>\"stub_incorrect_value\"}\n\n"
          )
          subject << the_assertion
        end
      end

    end
  end
end
