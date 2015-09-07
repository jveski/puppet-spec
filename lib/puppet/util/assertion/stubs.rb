require 'puppet/resource/type'

module Puppet::Util::Assertion
  class Stubs

    # This type reimplements the Puppet::Resource::Type class
    # and overwrites the parameter validation in order to
    # allow any param to be assigned a value.
    class Type < Puppet::Resource::Type
      def valid_parameter?(name)
        true
      end
    end

  end
end
