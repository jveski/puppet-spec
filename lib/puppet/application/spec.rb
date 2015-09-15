require 'puppet'
require 'puppet/test/test_helper'
require 'puppet/util/assertion/reporter'
require 'fileutils'

class Puppet::Application::Spec < Puppet::Application

  option("--manifest manifest",  "-m manifest")

  attr_reader :reporter

  def run_command
    @reporter = Puppet::Util::Assertion::Reporter.new

    begin
      Puppet::Test::TestHelper.initialize
      evaluate_assertions
      reporter.print_footer
    rescue Exception => e
      reporter.print_error(e)
    end

    exit 1 unless reporter.failed == 0
    exit 0
  end

  def evaluate_assertions
    if options[:manifest]
      process_spec(options[:manifest])
    else
      process_spec_directory(specdir)
    end
  end

  def process_spec_directory(specdir)
    Dir.glob("#{specdir}/**/*_spec.pp").map { |spec| process_spec(spec) }
  end

  def process_spec(path)
    catalog = catalog(path)

    assertions = catalog.resources.select {|res| res.type == 'Assertion' }
    assertions.each do |res|
      # Get the subject resource from the catalog rather than the
      # reference provided from the parser. The reference's resource
      # object does not contain any parameters for whatever reason.
      catalog_subject = catalog.resource(res[:subject].to_s)
      res[:subject] = catalog_subject if catalog_subject

      reporter << res.to_ral
    end
  end

  def catalog(path)
    Puppet::Test::TestHelper.before_each_test
    Puppet[:code] = File.read(path)

    node = Puppet::Node.new("spec")
    modulepath = get_modulepath(node)
    link_module(modulepath)
    catalog = Puppet::Resource::Catalog.indirection.find(node.name, :use_node => node)
    catalog.to_ral

    Puppet::Test::TestHelper.after_each_test
    catalog
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
      raise 'No spec directory was found under the CWD. A spec manifest can be specified with the --manifest flag'
    end
    specdir
  end

end
