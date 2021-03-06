Puppet::Type.newtype(:assertion) do

  @doc = "An assertion on the state of a resource in the catalog"

  validate do
    fail Puppet::Error, "a subject is required" unless @parameters[:subject]
    fail Puppet::Error, "an assertion on the absence of a resource cannot have an attribute" if @parameters[:attribute] and @parameters[:ensure].value == 'absent'
    fail Puppet::Error, "an assertion on the absence of a resource cannot have an expectation" if @parameters[:expectation] and @parameters[:ensure].value == 'absent'
    fail Puppet::Error, "an attribute is required when an expectation is given" if @parameters[:expectation] and not @parameters[:attribute]
    fail Puppet::Error, "an expectation is required when an attribute is given" if @parameters[:attribute] and not @parameters[:expectation]
  end

  newparam(:name) do
    desc "A plain text message describing what the assertion is attempting to prove.

    The given text should form a sentence using the type's name.
    Example: assertion { 'that the configuration file has the correct contents': }
    "
  end

  newparam(:subject) do
    desc "A reference to the resource to be asserted upon.

    The referenced resource will be the subject of any assertions made as a result of this resource declaration.
    "

    validate do |value|
      fail Puppet::Error, "Subject must be a resource reference" unless value.is_a? Puppet::Resource
    end
  end

  newparam(:attribute) do
    desc "An attribute of the subject resource to assert against"
  end

  newparam(:expectation) do
    desc "The expected value of the subject's attribute"
  end

  newparam(:ensure) do
    desc "If ensure is set to absent, the resource will assert for the absence of the subject in the catalog.

    Defaults to present.
    "

    defaultto "present"

    validate do |value|
      fail Puppet::Error, "Ensure only accepts values 'present' or 'absent'" unless value == 'present' or value == 'absent'
    end

    # Stub out the retrieve method since
    # the Puppet internals require any param
    # named ensure to have it. Grr.
    def retrieve
    end
  end

end
