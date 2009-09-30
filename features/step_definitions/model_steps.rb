Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |h|
    Factory(factory, h)
  end
end

Then /^I should have ([0-9])+ farms?$/ do |count|
    Farm.count.should == count.to_i
  
end

Then /^I should not be on (.+)$/ do |page_name|
  URI.parse(current_url).path.should != path_to(page_name)
end