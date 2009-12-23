## factories for rspec only!
## watch out for existing fixtures

Factory.define :role do |f|
  f.name "test role"
  f.description "test description"
  f.platform "windows"
  
  
end

Factory.define :farm do |f|
  f.name "test"
  f.description "test farm"
  # f.sequence(:ami_id) { |n| "ami-abcd100#{n}"}
  f.ami_id "ami-b96586d0"
  f.min 0
  f.max 2
  f.key_pair_name "admin-systems"
  f.security_groups "default,sequest"
  f.farm_type "compute"
  f.association :role
  
  
end



Factory.define :instance do |f|
   f.sequence(:instance_id) { |n| "i-abcd100#{n}"}
   f.ec2_state "running"
   f.state "idle"
   f.association :farm
   f.launch_time Time.now

end





