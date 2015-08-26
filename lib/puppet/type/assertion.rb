class Puppet::Parameter::Assertable < Puppet::Parameter; end

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
