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

  newparam(:attributes) do
    desc "A hash of resource attributes to be evaluated against the corresponding values on the subject resource."

    validate do |value|
      fail Puppet::Error, "You must provide attributes to be asserted" unless value
      fail Puppet::Error, "Attributes must be a hash" unless value.is_a? Hash
    end
  end

  # Assert takes an assertion resource
  # and returns a hash containing the
  # data to be presented back to the
  # user.
  def self.assert(res)
    res[:attributes].map do |attr, value|
      result = {
        :assertion => res,
        :attribute => attr,
      }
      result[:success] = value == res[:subject][attr]
      result
    end
  end

end
