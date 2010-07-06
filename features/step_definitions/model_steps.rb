Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |h|
    Factory(factory, h)
  end
end

Then /^I should have ([0-9])+ farms?$/ do |count|
    Farm.count.should == count.to_i
end

Then /^I should have ([0-9])+ running instances? with ami_id "(.+)"$/ do |count, ami_id|
    farm = Farm.find_by_ami_id(ami_id)
    (farm.instances.select{|i| i.running?}).size.should == count.to_i
    
end



