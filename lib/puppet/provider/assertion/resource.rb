Puppet::Type.type(:assertion).provide(:resource) do
  # The resource assertion provider is just a stub.
  # Assertion logic is handled from the spec application,
  # the type/provider are simply a means of getting
  # assertion data into the catalog where it will
  # be evaluated by the application.
end
