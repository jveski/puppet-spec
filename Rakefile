require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |config|
  config.rspec_opts = "--color"
end

task(:acceptance) do
  result = `cd spec/acceptance; bundle exec puppet spec`
  expectation = "\e[0;32m.\e[0m\n\n\e[0;31m1) Assertion the configuration file has the correct contents failed on File[/tmp/test]\n\e[0m\e[0;34m  Wanted: \e[0mcontent => 'not the contents'\n\e[0;34m  Got:    \e[0mcontent => 'the contents'\n\n\e[0;33mEvaluated 5 assertions\n\e[0m"
  unless result == expectation
    raise "Check yoself, acceptance is failing."
    puts result.inspect
  end
end
