require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet/application/spec'

describe Puppet::Application::Spec do

  describe ".run_command" do
    before do
      Puppet::Test::TestHelper.stubs(:initialize)
      subject.stubs(:process_spec_directory)
      subject.stubs(:print)
      subject.stubs(:exit)
      subject.stubs(:specdir).returns(:stub_specdir)
    end

    it "should initialize Puppet" do
      Puppet::Test::TestHelper.expects(:initialize)
      subject.run_command
    end

    it "should process the spec directory" do
      subject.expects(:process_spec_directory).with(:stub_specdir)
      subject.run_command
    end

    context "when an error is not raised" do
      it "should not print to the console" do
        subject.run_command
        subject.expects(:print).never
      end

      it "should not exit" do
        subject.run_command
        subject.expects(:exit).never
      end
    end

    context "when an error is raised" do
      let(:the_error) { Exception.new('stub exception') }
      before { subject.stubs(:process_spec_directory).raises(the_error) }

      it "should print it to the console" do
        subject.expects(:print).with("\e[0;31mstub exception\n\e[0m")
        subject.run_command
      end

      it "should exit 1" do
        subject.expects(:exit).with(1)
        subject.run_command
      end
    end
  end

  describe ".process_spec_directory" do
    let(:the_files) {[
      :stub_spec1,
      :stub_spec2,
      :stub_spec3,
    ]}

    before do
      subject.stubs(:process_spec).with(:stub_spec1).returns(:stub_result1)
      subject.stubs(:process_spec).with(:stub_spec2).returns(:stub_result2)
      subject.stubs(:process_spec).with(:stub_spec3).returns([:stub_result3])
      subject.stubs(:visit_assertions).returns(:stub_results)
      subject.stubs(:print)
      Dir.stubs(:glob).returns(the_files)
    end

    it "should evaluate the specdir" do
      Dir.expects(:glob).with('stub_path/**/*_spec.pp').returns(the_files)
      subject.process_spec_directory('stub_path')
    end

    it "should process each spec" do
      subject.expects(:process_spec).once.with(the_files[0])
      subject.expects(:process_spec).once.with(the_files[1])
      subject.expects(:process_spec).once.with(the_files[2])
      subject.process_spec_directory('stub_path')
    end

    it "should evaluate the assertion resources" do
      subject.expects(:visit_assertions).with(
        [:stub_result1, :stub_result2, :stub_result3]
      ).returns(:stub_results)
      subject.process_spec_directory('stub_path')
    end

    it "should print the results" do
      subject.expects(:print).once.with("\n\n")
      subject.expects(:print).once.with(:stub_results)
      subject.process_spec_directory('stub_path')
    end
  end

  describe ".process_spec" do
    let(:the_catalog) { stub(:resources => the_resources) }
    let(:the_resources) {[
      stub(:[]= => nil, :type => 'Assertion', :[] => :stub_subject1),
      stub(:[]= => nil, :type => 'Not an Assertion', :[] => :stub_subject2),
    ]}

    before do
      subject.stubs(:catalog).returns(the_catalog)
      the_catalog.stubs(:resource).with('stub_subject1').returns(:stub_catalog_resource)
      subject.stubs(:notify_compiled)
      subject.stubs(:evaluate)
      subject.stubs(:visit_assertions).returns(:stub_assertions)
    end

    it "should compile the catalog" do
      subject.expects(:catalog).with(:stub_path).returns(the_catalog)
      subject.process_spec(:stub_path)
    end

    it "should print a notification" do
      subject.expects(:notify_compiled)
      subject.process_spec(:stub_path)
    end

    it "should set each subject from the catalog" do
      the_resources[0].expects(:[]=).with(:subject, :stub_catalog_resource)
      subject.process_spec(:stub_path)
    end

    it "should return the assertions" do
      expect(subject.process_spec(:stub_path)).to eq([the_resources[0]])
    end
  end

  describe ".catalog" do
    let(:the_node) { stub('node', :name => :stub_name) }
    let(:the_catalog) { stub(:to_ral => nil) }
    let(:the_indirection) { stub('indirection', :find => the_catalog) }

    before do
      Puppet::Test::TestHelper.stubs(:before_each_test)
      Puppet::Test::TestHelper.stubs(:after_each_test)
      Puppet.stubs(:[]=)
      Puppet::Node.stubs(:new).returns(the_node)
      Puppet::Resource::Catalog.stubs(:indirection).returns(the_indirection)
      File.stubs(:read).returns(:stub_file)
      subject.stubs(:get_modulepath).returns(:the_modulepath)
      subject.stubs(:link_module)
    end

    it "should initialize Puppet" do
      Puppet::Test::TestHelper.expects(:before_each_test)
      subject.catalog(:stub_path)
    end

    it "should read the spec manifest" do
      File.expects(:read).with(:stub_path)
      subject.catalog(:stub_path)
    end

    it "should give Puppet the spec manifest" do
      Puppet.expects(:[]=).with(:code, :stub_file)
      subject.catalog(:stub_path)
    end

    it "should calculate the modulepath" do
      subject.expects(:get_modulepath).with(the_node)
      subject.catalog(:stub_path)
    end

    it "should create the module symlink" do
      subject.expects(:link_module)
      subject.catalog(:stub_path)
    end

    it "should compile the catalog" do
      the_indirection.expects(:find).with(:stub_name, :use_node => the_node).returns(the_catalog)
      subject.catalog(:stub_path)
    end

    it "should finalize the catalog" do
      the_catalog.expects(:to_ral)
      subject.catalog(:stub_path)
    end

    it "should clean up the test" do
      Puppet::Test::TestHelper.expects(:after_each_test)
      subject.catalog(:stub_path)
    end

    it "should return the catalog" do
      expect(subject.catalog(:stub_path)).to eq(the_catalog)
    end
  end

  describe ".visit_assertions" do
    context "when given one passing assertion" do
      let(:the_assertions) {[
        {
          :expectation => 'stub_expectation_1',
          :attribute   => 'stub_attribute_1',
          :name        => 'stub_name_1',
          :subject     => {
            'stub_attribute_1' => 'stub_expectation_1',
          },
        }
      ]}
      it "should return the expected output" do
        expect(subject.visit_assertions(the_assertions)).to eq(
          "\e[0;33mEvaluated 1 assertion\n\e[0m"
        )
      end
    end

    context "when given two passing assertions" do
      let(:the_assertions) {[
        {
          :expectation => 'stub_expectation_1',
          :attribute   => 'stub_attribute_1',
          :name        => 'stub_name_1',
          :subject     => {
            'stub_attribute_1' => 'stub_expectation_1',
          },
        },
        {
          :expectation => 'stub_expectation_2',
          :attribute   => 'stub_attribute_2',
          :name        => 'stub_name_2',
          :subject     => {
            'stub_attribute_2' => 'stub_expectation_2',
          },
        }
      ]}
      it "should return the expected output" do
        expect(subject.visit_assertions(the_assertions)).to eq(
          "\e[0;33mEvaluated 2 assertions\n\e[0m"
        )
      end
    end

    context "when given one passing and one failing assertion" do
      let(:the_assertions) {[
        {
          :expectation => 'stub_expectation_1',
          :attribute   => 'stub_attribute_1',
          :name        => 'stub_name_1',
          :subject     => {
            'stub_attribute_1' => 'stub_expectation_1',
          },
        },
        {
          :expectation => 'stub_expectation_2',
          :attribute   => 'stub_attribute_2',
          :name        => 'stub_name_2',
          :subject     => {
            'stub_attribute_2' => 'not the expectation',
          },
        }
      ]}
      it "should return the expected output" do
        expect(subject.visit_assertions(the_assertions)).to eq(
          "\e[0;31m1) Assertion stub_name_2 failed on {\"stub_attribute_2\"=>\"not the expectation\"}\n\e[0m\e[0;34m  Wanted: \e[0mstub_attribute_2 => 'stub_expectation_2'\n\e[0;34m  Got:    \e[0mstub_attribute_2 => 'not the expectation'\n\n\e[0;33mEvaluated 2 assertions\n\e[0m"
        )
      end
    end
  end

  describe ".notify_compiled" do
    before { subject.stubs(:print) }

    it "should print a green period" do
      subject.expects(:print).with("\e[0;32m.\e[0m")
      subject.notify_compiled
    end
  end

  describe ".get_modulepath" do
    context "when given a node object" do
      let(:the_environment) { stub('environment', :full_modulepath => [:stub_path, 2]) }
      let(:the_node) { stub('node', :environment => the_environment) }

      it "should return the correct modulepath" do
        expect(subject.get_modulepath(the_node)).to eq(:stub_path)
      end
    end
  end

  describe ".link_module" do
    before do
      Dir.stubs(:pwd).returns(:stub_pwd)
      Dir.stubs(:exist?)
      File.stubs(:symlink?)
      File.stubs(:basename).returns(:stub_name)
      File.stubs(:join).returns(:stub_sympath)
      FileUtils.stubs(:mkdir_p)
      FileUtils.stubs(:ln_s)
    end

    it "should get the module's directory" do
      Dir.expects(:pwd).returns(:stub_pwd)
      subject.link_module(:stub_module)
    end

    it "should get the module's name" do
      File.expects(:basename).with(:stub_pwd).returns(:stub_name)
      subject.link_module(:stub_module)
    end

    it "should get the symlink's path" do
      File.expects(:join).with(:stub_module, :stub_name).returns(:stub_sympath)
      subject.link_module(:stub_module)
    end

    it "should check if the modulepath exists" do
      Dir.expects(:exist?).with(:stub_module)
      subject.link_module(:stub_module)
    end

    context "when the modulepath exists" do
      before { Dir.stubs(:exist?).returns(true) }
      it "should not create the modulepath directory" do
        FileUtils.expects(:mkdir_p).never
        subject.link_module(:stub_module)
      end
    end

    context "when the modulepath does not exist" do
      before { Dir.stubs(:exist?).returns(false) }
      it "should create the modulepath directory" do
        FileUtils.expects(:mkdir_p).with(:stub_module)
        subject.link_module(:stub_module)
      end
    end

    it "should check if the symlink exists" do
      File.expects(:symlink?).with(:stub_sympath)
      subject.link_module(:stub_module)
    end

    context "when the symlink does exist" do
      before { File.stubs(:symlink?).returns(true) }
      it "should not create the symlink" do
        FileUtils.expects(:ln_s).never
        subject.link_module(:stub_module)
      end
    end

    context "when the symlink does not exist" do
      before { File.stubs(:symlink?).returns(false) }
      it "should not create the symlink" do
        FileUtils.expects(:ln_s).with(:stub_pwd, :stub_sympath)
        subject.link_module(:stub_module)
      end
    end
  end

  describe ".specdir" do
    before do
      Dir.stubs(:pwd).returns(:stub_pwd)
      Dir.stubs(:exist?).returns(true)
      File.stubs(:join).returns(:stub_specdir)
    end

    it "should get the pwd" do
      Dir.expects(:pwd).returns(:stub_pwd)
      subject.specdir
    end

    it "should parse the specdir" do
      File.expects(:join).with(:stub_pwd, 'spec').returns(:stub_specdir)
      subject.specdir
    end

    context "when the CWD contains a spec directory" do
      before { Dir.stubs(:exist?).returns(true) }

      it "should return the path to the specdir" do
        expect(subject.specdir).to eq(:stub_specdir)
      end

      it "should return the specdir" do
        expect(subject.specdir).to eq(:stub_specdir)
      end
    end

    context "when the CWD does not contain a spec directory" do
      before { Dir.stubs(:exist?).returns(false) }

      it "should raise an error" do
        expect{subject.specdir}.to raise_error(
          'No spec directory was found under the CWD. You can optionally specifiy one with --specdir'
        )
      end
    end
  end

end
