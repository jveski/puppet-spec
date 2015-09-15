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

      # Given an assertion resource, evaluate it for success,
      # and on failure, call the appropriate method responsible to render the
      # message, and increment the counter(s).
      def <<(assertion)
        count

        if assertion[:ensure] != 'absent' and assertion[:subject] == :absent
          fail
          expected_present
          return
        elsif assertion[:ensure] == 'absent' and assertion[:subject] != :absent
          fail
          expected_absent
          return
        end

        if assertion.provider.failed?
          fail
          inequal_value(assertion)
          return
        end

      end

      # Print the summary of evaluated assertions
      def print_footer
        # Shim the reporter into the local scope
        reporter = self

        style do
          if reporter.evaluated == 1
            yellow "Evaluated 1 assertion"
            newline
          else
            yellow "Evaluated #{reporter.evaluated} assertions"
            newline
          end
        end
      end

      def print_error(err)
        fail #Mark an assertion so the application exits 1
        style do
          red err.message
          newline
        end
      end

      # Print the appropriate error message when an assertion's
      # subject is found in the catalog but was intended to be
      # absent.
      def expected_absent(assertion)
        fail

        # Shim the value of failed into the
        # local scope in order to access it
        # from the style proc.
        failed = @failed

        style do
          red      "#{failed}) Assertion #{assertion[:name]} failed on #{assertion[:subject].to_s}"
          newline
          blue     "  Subject was expected to be absent from the catalog, but was present"
          newline
          newline
        end
      end

      # Print the appropriate error message when an assertion's
      # subject is not found in the catalog.
      def expected_present(assertion)
        fail

        # Shim the value of failed into the
        # local scope in order to access it
        # from the style proc.
        failed = @failed

        style do
          red      "#{failed}) Assertion #{assertion[:name]} failed on #{assertion[:subject].to_s}"
          newline
          blue     "  Subject was expected to be present in the catalog, but was absent"
          newline
          newline
        end
      end

      # Pretty print the results of an assertion to the console
      def inequal_value(assertion)
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
