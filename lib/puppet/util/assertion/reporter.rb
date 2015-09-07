require 'puppet/util/assertion/printer'

module Puppet::Util
  module Assertion
    class Reporter
      include Puppet::Util::Assertion::Printer::Styler

      attr_reader :evaluated, :failed

      def initialize
        @evaluated = 0
        @failed = 0
      end

      # Given an assertion resource, evaluate it for success
      # and send it to .report on failure. Increment the counter
      # for each resource, and the failed counter for failed resources.
      def <<(assertion)
        count
        if assertion.provider.failed?
          fail
          report(assertion)
        end
      end

      # Pretty print the results of an assertion to the console
      def report(assertion)
        # Shim the value of failed into the
        # local scope in order to access it
        # from the style proc.
        failed = @failed

        style do
          red      "#{failed}) Assertion #{assertion[:name]} failed on #{assertion[:subject].to_s}"
          newline

          yellow   "  On line #{assertion[:subject].line} of #{assertion.provider.relative_path}"
          newline

          blue     "  Wanted: "
          white    assertion.provider.wanted.to_s
          newline

          blue     "  Got:    "
          white    assertion.provider.got.to_s
          newline
          newline
        end
      end

      def count
        @evaluated += 1
      end

      def fail
        @failed += 1
      end

    end
  end
end
