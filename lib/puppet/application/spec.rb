require 'puppet'
require 'puppet/test/test_helper'
require 'puppet/util/colors'
require 'fileutils'

class Puppet::Application::Spec < Puppet::Application
  include Puppet::Util::Colors

  # TODO
  def run_command
    begin
      Puppet::Test::TestHelper.initialize
      process_spec_directory(specdir)
    rescue Exception => e
      puts e.message
    end
  end

  def process_spec_directory(specdir)
    # Evaluate the spec directory
    # and process each applicable
    # file.
    Dir.glob("#{specdir}/**/*_spec.pp").map { |spec| process_spec(spec) }
  end

  def process_spec(path)
    # Compile a catalog for the spec
    catalog = catalog(path)

    # Print notification that a
    # spec was successfully compiled
    notify_compiled

    # Evaluate the catalog for
    # assertions. This method
    # is responsible to print
    # the appropriate output.
    results = evaluate(catalog)

    print parse_results(results)
  end

  def catalog(path)
    Puppet::Test::TestHelper.before_each_test
    Puppet[:code] = File.read(path)

    node = Puppet::Node.new("spec")
    modulepath = get_modulepath(node)
    link_module(modulepath)
    catalog = Puppet::Resource::Catalog.indirection.find(node.name, :use_node => node)

    Puppet::Test::TestHelper.after_each_test
    catalog
  end

  # Evaluate visits each assertion resource
  # and makes the assertion. Returns an array
  # of assertion results. See .assert.
  def evaluate(catalog)
    results = catalog.resources.map do |res|
      if res.type == 'Assertion'
        # Get the subject from the
        # catalog. At this point, 
        # the subject resource obj
        # has not been visited and
        # thus has no params.
        res[:subject] = catalog.resource(res[:subject].to_s)

        assert(res)
      end
    end

    # Remove the nil objects
    # resulting from non-assertion
    # resources
    results.flatten!
    results.delete(nil)
    results
  end

  # Assert takes an assertion resource
  # and asserts each parameter for equality
  # against the corresponding attribute of
  # its subject.
  def assert(assertion)
    # TODO
  end

  # Parse results formats the assertion
  # result hash and returns a string
  # ready to be presented to the user.
  def parse_results(results)
    # TODO
  end

  # Print an rspec style dot
  # to signify spec compilation
  def notify_compiled
    print colorize(:green, '.')
  end

  # Given a node object, return
  # the first modulepath
  def get_modulepath(node)
    node.environment.full_modulepath[0]
  end

  # Ensure that a symlink is present
  # pointing from the node's env
  # to the current directory
  def link_module(modulepath)
    pwd = Dir.pwd
    name = File.basename(pwd)
    symlink = File.join(modulepath, name)

    # Ensure that the modulepath exists
    # within the temp environment
    FileUtils.mkdir_p(modulepath) unless Dir.exist?(modulepath)

    # Ensure that a symlink to the
    # cwd exists
    FileUtils.ln_s(pwd, symlink) unless File.symlink?(symlink)
  end

  # Return the specdir under the
  # CWD or raise an error if not
  # found.
  def specdir
    pwd = Dir.pwd
    specdir = File.join(pwd, 'spec')
    unless Dir.exist?(specdir)
      raise 'No spec directory was found under the CWD. You can optionally specifiy one with --specdir'
    end
    specdir
  end

end
