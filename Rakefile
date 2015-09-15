require 'puppetlabs_spec_helper/rake_tasks'

task(:acceptance) do
  rake_result = `cd spec/acceptance; bundle exec rake puppetspec`
  cli_result = `cd spec/acceptance; bundle exec puppet spec`
  expectation = "\e[0;31m1) Assertion that the configuration file has the correct contents failed on File[/tmp/test]\e[0m\n\e[0;33m  On line 13 of init.pp\e[0m\n\e[0;34m  Wanted: \e[0m{\"content\"=>\"not the contents\"}\n\e[0;34m  Got:    \e[0m{\"content\"=>\"the contents\"}\n\n\e[0;31m2) Assertion that the resource is in the catalog failed on File[/tmp/should/be/around]\e[0m\n\e[0;34m  Subject was expected to be present in the catalog, but was absent\e[0m\n\n\e[0;33mEvaluated 6 assertions\e[0m\n"

  unless rake_result == expectation
    puts rake_result.inspect, expectation.inspect
    raise "Check yoself, Rakefile acceptance is failing."
  end

  unless cli_result == expectation
    puts cli_result.inspect, expectation.inspect
    raise "Check yoself, CLI acceptance is failing."
  end
end
