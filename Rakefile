require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |config|
  config.rspec_opts = "--color"
end

task(:acceptance) do
  result = `cd spec/acceptance; bundle exec puppet spec`
  unless result.include?('Assertion the configuration file has the correct contents failed on File[/tmp/test]') and result.include?('Evaluated 4 assertions')
    puts result
    raise "Check yoself, acceptance is failing."
  end
end
