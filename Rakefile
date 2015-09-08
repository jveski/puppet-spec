require 'puppetlabs_spec_helper/rake_tasks'

task(:acceptance) do
  result = `cd spec/acceptance; bundle exec rake puppetspec`
  expectation = "\e[0;31m1) Assertion the configuration file has the correct contents failed on File[/tmp/test]\e[0m\n\e[0;33m  On line 13 of init.pp\e[0m\n\e[0;34m  Wanted: \e[0m{\"content\"=>\"not the contents\"}\n\e[0;34m  Got:    \e[0m{\"content\"=>\"the contents\"}\n\n\e[0;33mEvaluated 6 assertions\n\e[0m"
  unless result == expectation
    puts result.inspect
    raise "Check yoself, acceptance is failing."
  end
end
