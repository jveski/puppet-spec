require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/util/assertion/reporter'

describe Puppet::Util::Assertion::Reporter do

  # Covers the integration of the assertion resource
  # type/provider with the reporter.
  describe ".<<" do
    before { subject.stubs(:print) }
    let(:the_subject_catalog) { :stub_catalog }

    context "with a single assertion resource" do
      let(:the_subject_value) { 'stub_value' }
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
        subj.catalog = the_subject_catalog
        subj
      end

      context "with an assertion that expects the subject to be present" do
        before { the_assertion[:ensure] = 'present' }

        context "with no subject" do
          let(:the_subject_catalog) { nil }

          it "should print the expected message" do
            subject.expects(:print).with(
              "\e[0;31m1) Assertion stub assertion 1 failed on Stub_type[stub_title]\e[0m\n\e[0;34m  Subject was expected to be present in the catalog, but was absent\e[0m\n\n"
            )
            subject << the_assertion
          end
        end

        context "with a subject" do
          it "should not print a message" do
            subject.expects(:print).never
            subject << the_assertion
          end

          context "when the attribute's value matches the expectation" do
            let(:the_subject_value) { 'stub_value' }

            it "should print the expected output" do
              subject.expects(:print).never
              subject << the_assertion
            end
          end

          context "when the attribute's value does not match the expectation" do
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

      context "with an assertion that expects the subject to be absent" do
        before { the_assertion[:ensure] = 'absent' }

        context "with no subject" do
          let(:the_subject_catalog) { nil }

          it "should not print a message" do
            subject.expects(:print).never
            subject << the_assertion
          end
        end

        context "with a subject" do
          it "should print the expected message" do
            subject.expects(:print).with(
              "\e[0;31m1) Assertion stub assertion 1 failed on Stub_type[stub_title]\e[0m\n\e[0;34m  Subject was expected to be absent from the catalog, but was present\e[0m\n\n"
            )
            subject << the_assertion
          end
        end
      end

    end
  end

  describe ".print_error" do
    let(:the_error) { stub(:message => 'stub message') }

    before { subject.stubs(:print) }

    it "should print the expected message" do
      subject.expects(:print).with("\e[0;31mstub message\e[0m\n")
      subject.print_error(the_error)
    end

  end
end
