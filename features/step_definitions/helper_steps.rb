#HELPERS for various features

When /^I wait for (\d+) seconds?$/ do |n|
  sleep n.to_i
end

When /^I run Delayed Jobs$/ do
  Delayed::Job.reserve_and_run_one_job
end

# for special UI multiselect

When /^I select index "([^\"]*)" from multiselect$/ do |ind|
  within(:css, "li.ui-element") do
        all('a')[ind.to_i].click
  end
end