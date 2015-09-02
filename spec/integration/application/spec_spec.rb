require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/application/spec'

describe Puppet::Application::Spec do
  describe ".visit_assertions" do
    context "with a single passing assertion" do
      let(:the_assertions) {[
        Puppet::Type.type(:assertion).new(
          :name        => 'stub assertion 1',
          :attribute   => 'content',
          :expectation => 'present',
          :subject     => Puppet::Type.type(:file).new(
            :name   => '/tmp/test',
            :ensure => 'present',
          ).to_resource
        )
      ]}

      it "should return the expected output" do
        expect(subject.visit_assertions(the_assertions)).to eq({
          :count  => 1,
          :failed => 1,
          :msg    => "\e[0;31m1) Assertion stub assertion 1 failed on File[/tmp/test]\n\e[0m\e[0;34m  Wanted: \e[0mcontent => 'present'\n\e[0;34m  Got:    \e[0mcontent => ''\n\n",
        })
      end
    end

    context "a single assertion with incorrect value" do
      let(:the_assertions) {[
        Puppet::Type.type(:assertion).new(
          :name        => 'stub assertion 1',
          :attribute   => 'content',
          :expectation => 'present',
          :subject     => Puppet::Type.type(:file).new(
            :name   => '/tmp/test',
            :ensure => 'absent',
          ).to_resource
        )
      ]}

      it "should return the expected output" do
        expect(subject.visit_assertions(the_assertions)).to eq({
          :count  => 1,
          :failed => 1,
          :msg    => "\e[0;31m1) Assertion stub assertion 1 failed on File[/tmp/test]\n\e[0m\e[0;34m  Wanted: \e[0mcontent => 'present'\n\e[0;34m  Got:    \e[0mcontent => ''\n\n",
        })
      end
    end

    context "a single assertion with no subject" do
      let(:the_assertions) {[
        Puppet::Type.type(:assertion).new(
          :name        => 'stub assertion 1',
          :attribute   => 'content',
          :expectation => 'present',
        ).to_resource
      ]}

      it "should raise an error" do
        expect{subject.visit_assertions(the_assertions)}.to raise_error(
          'Assertion[stub assertion 1] requires a subject'
        )
      end
    end

    context "a single assertion with an expectation and no attribute" do
      let(:the_assertions) {[
        Puppet::Type.type(:assertion).new(
          :name        => 'stub assertion 1',
          :expectation => 'present',
          :subject     => Puppet::Type.type(:file).new(
            :name   => '/tmp/test',
            :ensure => 'present',
          ).to_resource
        ).to_resource
      ]}

      it "should raise an error" do
        expect{subject.visit_assertions(the_assertions)}.to raise_error(
          'Assertion[stub assertion 1] requires an attribute when an expectation is given'
        )
      end
    end

    context "a single assertion with no attribute and no expectation" do
      let(:the_assertions) {[
        Puppet::Type.type(:assertion).new(
          :name        => 'stub assertion 1',
          :subject     => Puppet::Type.type(:file).new(
            :name   => '/tmp/test',
            :ensure => 'present',
          ).to_resource
        ).to_resource
      ]}

      it "should raise an error" do
        expect(subject.visit_assertions(the_assertions)).to eq({
          :count  => 1,
          :failed => 0,
          :msg    => "",
        })
      end
    end

  end
end
