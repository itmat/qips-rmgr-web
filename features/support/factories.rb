require 'factory_girl'

Factory.define :farm do |f|
  f.key_pair_name "admin-systems"
  f.security_groups "default,sequest"
end

Factory.define :instance do |f|
  f.ec2_state "running"
end



