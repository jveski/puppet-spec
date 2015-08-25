class Puppet::Parameter::Assertable < Puppet::Parameter
  # Retrieve simply invokes the provider and passes
  # the params's name
  def retrieve
    @resource.provider.assert(name)
  end
end

Puppet::Type.newtype(:assertion) do

  @doc = "Makes assertions on the state of a resource in the catalog.

  The assertion type is intended to serve as a means of natively testing Puppet code.
  Arbirary parameters are allowed. Each will result in an equality assertion against
  the corresponding attribute of the subject resource (see the subject parameter).

  If any of the assertions fail, an error will be logged.
  "

  newparam(:name) do
    desc "A plain text message describing what the assertion is intended to prove.

    Example: 'the configuration file'
    "
  end

  newparam(:subject) do
    # Retrieve takes the resource reference and
    # resolves it to the instance of the referenced
    # resource found in the catalog.
    def retrieve
      @resource[:subject] = @resource.catalog.resource(@resource[:subject].to_s)
    end

    desc "A reference to the resource to be asserted upon.

    The referenced resource will be the subject of any assertions made as a result of this resource declaration.
    "
  end

  # Retrieve recurses into each param, checks if
  # it responds to .retrieve, and if true, calls it.
  # If the param does not respond to .retrieve, it
  # will not be called, and no error will be raised.
  def retrieve
    parameters.each do |name, param|
      param.retrieve if param.respond_to?(:retrieve)
    end
  end

  # We reimplement this method in order to allow
  # for arbitrary resource parameters. It appends
  # the appropriate params class to the attrclasses
  # hash at the key for the given attribute name if
  # the attribute's class has not already been defined.
  def self.validattr?(name)
    # Type's retrieve method will
    # create the ensure property
    # if this method returns true
    # when given :ensure.
    return false if name == :ensure

    @attrclasses ||= {}

    unless [:name, :subject].include?(name)
      @attrclasses[name] ||= newparam(name, :parent => Puppet::Parameter::Assertable)
    end

    true
  end

end
