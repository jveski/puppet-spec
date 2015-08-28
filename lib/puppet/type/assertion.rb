Puppet::Type.newtype(:assertion) do

  @doc = "Makes assertions on the state of a resource in the catalog.

  The assertion type defines an assertion that will be evaluated by the
  spec application.

  Arbirary parameters are allowed. Each will result in an equality assertion against
  the corresponding attribute of the subject resource (see the subject parameter).
  "

  newparam(:name) do
    desc "A plain text message describing what the assertion is intended to prove.

    Example: 'the configuration file'
    "
  end

  newparam(:subject) do
    desc "A reference to the resource to be asserted upon.

    The referenced resource will be the subject of any assertions made as a result of this resource declaration.
    "

    validate do |value|
      fail Puppet::Error, "You must provide an assertion subject" unless value
      fail Puppet::Error, "Attributes must be a resource reference" unless value.is_a? Puppet::Resource
    end
  end

  newparam(:attribute) do
    desc "An attribute of the subject resource to assert against"

    validate do |value|
      fail Puppet::Error, "You must provide attribute to be asserted" unless value

      valid = @resource[:subject].valid_parameter?(value)
      fail Puppet::Error, "#{value} is not a valid attribute of #{@resource[:subject].to_s}" unless valid
    end
  end

  newparam(:expectation) do
    desc "The expected value of the subject's attribute"
  end

end
