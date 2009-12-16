require 'factory_girl'

Factory.define :role do |f|
  f.recipes Recipe.find(:all)
  f.sequence(:description) { |n| "test description #{n}"} 
end

Factory.define :recipe do |f|
end

Factory.define :farm do |f|
  f.key_pair_name "admin-systems"
  f.security_groups "default,sequest"
end

Factory.define :instance do |f|
  f.ec2_state "running"
end

Factory.define :user do |f|
  f.sequence(:username) { |n| "guest#{n}" }
  f.sequence(:email) { |n| "guest#{n}@mail.edu" }
  f.privilege 'restricted'
  # add password secret
  f.password 'secret'
  f.password_confirmation 'secret'

end

