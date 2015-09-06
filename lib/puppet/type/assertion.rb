Puppet::Type.newtype(:assertion) do

  @doc = "Makes assertions on the state of a resource in the catalog.

  The assertion type defines an assertion that will be evaluated by the
  spec application.
  "

  newparam(:name) do
    desc "A plain text message describing what the assertion is intended to prove.

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

end
