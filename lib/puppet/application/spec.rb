require 'puppet'
require 'puppet/test/test_helper'
require 'puppet/util/colors'
require 'fileutils'

class Puppet::Application::Spec < Puppet::Application
  include Puppet::Util::Colors

  def run_command
    begin
      Puppet::Test::TestHelper.initialize
      process_spec_directory(specdir)
    rescue Exception => e
      print colorize(:red, "#{e.message}\n")
      exit 1
    end
  end

  def process_spec_directory(specdir)
    results = Dir.glob("#{specdir}/**/*_spec.pp").map { |spec| process_spec(spec) }.flatten
    print "\n\n"
    print visit_assertions(results)
  end

  def process_spec(path)
    catalog = catalog(path)
    notify_compiled

    assertions = catalog.resources.select {|res| res.type == 'Assertion' }

    # Get the subject resource from the catalog rather than the
    # reference provided from the parser. The reference's resource
    # object does not contain any parameters for whatever reason.
    assertions.map do |res|
      res[:subject] = catalog.resource(res[:subject].to_s)
      res
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

  # Return a string that contains
  # output to be displayed to the
  # user which represents the results
  # of the assertions.
  def visit_assertions(assertions)
    count = 0
    failed_count = 0

    msg = assertions.map do |assertion|
      count += 1
      raise Puppet::Error, "#{assertion} requires a subject" unless assertion[:subject]
      raise Puppet::Error, "#{assertion} requires an attribute when an expectation is given" if assertion[:expectation] and not assertion[:attribute]

      unless assertion[:expectation] == assertion[:subject][assertion[:attribute]]
        failed_count += 1
        msg = colorize(:red, "#{failed_count}) Assertion #{assertion[:name]} failed on #{assertion[:subject]}\n")
        msg += colorize(:blue, "  Wanted: ")
        msg += "#{assertion[:attribute]} => '#{assertion[:expectation]}'\n"
        msg += colorize(:blue, "  Got:    ")
        msg += "#{assertion[:attribute]} => '#{assertion[:subject][assertion[:attribute]]}'\n\n"
      end
    end

    footer = "Evaluated #{count} assertion"
    footer += "s" unless count == 1
    msg.push(colorize(:yellow, "#{footer}\n"))
    
    msg.join
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
