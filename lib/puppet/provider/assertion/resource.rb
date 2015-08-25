Puppet::Type.type(:assertion).provide(:resource) do

  # Assert takes the name of a resource parameter and
  # asserts on its equality to the corresponding
  # field on the assertion resource.
  #
  # If the subject's type does not support the given
  # parameter, it will raise an appropriate error.
  # Similarly, if the assertion fails, an error will
  # be raised.
  def assert(param)
    unless @resource[:subject].class.valid_parameter?(param)
      raise Puppet::Error, "Cannot make an assertion on the value of parameter '#{param}' because the resource #{@resource[:subject].to_s} does not support it."
    end

    unless @resource[:subject][param] == @resource[param]
      raise Puppet::Error, "Assertion failed on parameter #{param}. Wanted value '#{@resource[param]}' got '#{@resource[:subject][param]}'"
    end
  end

end
