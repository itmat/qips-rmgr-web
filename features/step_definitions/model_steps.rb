Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |h|
    Factory(factory, h)
  end
end
