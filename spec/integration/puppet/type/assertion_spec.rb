require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/type/assertion'

describe Puppet::Type.type(:assertion) do
  let(:the_subject) { stub(:is_a? => Puppet::Resource) }
  
  subject do
    Puppet::Type.type(:assertion).new(
      :name        => 'stub name',
      :subject     => the_subject,
      :attribute   => 'stub attribute',
      :expectation => 'stub expectation',
    )
  end

  it "should assign the name" do
    expect(subject[:name]).to eq('stub name')
  end

  it "should assign the subject" do
    expect(subject[:subject]).to eq(the_subject)
  end

  it "should assign the attribute" do
    expect(subject[:attribute]).to eq('stub attribute')
  end

  it "should assign the expectation" do
    expect(subject[:expectation]).to eq('stub expectation')
  end

end
