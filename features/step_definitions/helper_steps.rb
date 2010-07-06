#HELPERS for various features

When /^I wait for (\d+) seconds?$/ do |n|
  puts "Waiting for #{n} seconds..."
  sleep n.to_i
end

When /^I run Delayed Jobs$/ do
  puts "Running a Delayed Job..."
  Delayed::Worker.new.work_off
end

# for special UI multiselect. ONLY works with selenium

When /^I select index (\d+) from multiselect$/ do |ind|
  within(:css, "li.ui-element") do
        all('a')[ind.to_i].click 
  end
end

When /^I remove index (\d+) from multiselect$/ do |ind|
  within(:css, "ul.selected") do
        all('a')[ind.to_i].click
  end
  
end


#should NOT be on a page:

Then /^I should not be on (.+)$/ do |page_name|
  URI.parse(current_url).path.should != path_to(page_name)
end


# refresh the page

When /^I refresh the page$/ do
  visit(current_url)
end