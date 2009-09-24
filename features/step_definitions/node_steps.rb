Given /^I have instances named (.+)$/ do |instances|
  instances.split(', ').each do |instance_id|
    Instance.create!(:instance_id => instance_id)
  end
end