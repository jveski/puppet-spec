Puppet::Type.type(:assertion).provide(:evaluator) do

  # Returns the complete path to the
  # subject's manifest after /manifests
  def relative_path
    @resource[:subject].file.split('manifests/').last
  end

  # Returns a hash containing the assertion's
  # attribute as the single key, with the value
  # of the expectation. Used for rendering the
  # results to the console.
  def wanted
    { @resource[:attribute] => @resource[:expectation] }
  end

  # Returns a hash containing the assertion's
  # attribute as the single key, with the value
  # of the subject's attribute. Used for rendering the
  # results to the console.
  def got
    { @resource[:attribute] => @resource[:subject][@resource[:attribute]] }
  end

  # Return false if the subject's attribute is
  # equal to the expectation, true otherwise.
  def failed?
    @resource[:expectation] != @resource[:subject][@resource[:attribute]]
  end

end
