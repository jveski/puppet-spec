require 'puppet/application/spec'

desc "Evaluate puppet-spec test cases and print the results"
task(:puppetspec) do
  Puppet::Application::Spec.new.run
end
