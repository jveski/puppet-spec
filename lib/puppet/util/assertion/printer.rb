require 'puppet/util/colors'

module Puppet::Util
  module Assertion
    class Printer
      include Puppet::Util::Colors

      attr_reader :stack

      def initialize
        @stack = []
      end

      def red(msg)
        stack << colorize(:red, msg)
      end

      def blue(msg)
        stack << colorize(:blue, msg)
      end

      def yellow(msg)
        stack << colorize(:yellow, msg)
      end

      def white(msg)
        stack << msg
      end

      def newline
        stack << "\n"
      end

      def to_s
        stack.join
      end

      # Styler is a mixin that provides a helper
      # method that parses a styled string by
      # evaluating the given proc on an instance
      # of Printer.
      module Styler
        def style(&proc)
          printer = Puppet::Util::Assertion::Printer.new
          printer.instance_eval(&proc)
          print printer.to_s
        end
      end

    end
  end
end
