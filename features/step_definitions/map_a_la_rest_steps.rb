Given /^the class:$/ do |code|
  eval code
end

When /^I send the dispatch:$/ do |dispatch|
  JSTP::Engine.instance.dispatch JSON.parse dispatch
end

Then /^I should have '(.+?)' in the test log$/ do |text|
  begin
    Testing.test_log.should include JSON.parse text  
  rescue JSON::ParserError => e
    Testing.test_log.should include text  
  end
end

Then /^I should have (\d+) in the test log$/ do |number|
  Testing.test_log.should include number.to_i
end