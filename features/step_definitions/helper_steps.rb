#HELPERS for various features

When /^I wait for (\d+) seconds?$/ do |n|
  sleep n.to_i
end

When /^I run Delayed Jobs$/ do
  Delayed::Job.reserve_and_run_one_job
end
