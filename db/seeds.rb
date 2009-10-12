# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


### some samples

roles = Role.create([{:name => 'sequest', :description => "test desc", :launch_buffer => 15, :prov_buffer => 10}, {:name => 'compute', :description => "test desc", :launch_buffer => 15, :prov_buffer => 10}])

farm = Farm.create({:name => 'TEST', :description => 'Test node server', :ami_id => 'ami-c544a5ac',
      :min => 0, :max => 3, :key => 'admin-systems', :groups => 'default, sequest', :role => roles.first})

farm1 = Farm.create({:name => 'TEST_PERSIST', :description => 'Test Persistent', :ami_id => 'ami-db57b6b2',
      :min => 1, :max => 1, :key => 'admin-systems', :groups => 'default, sequest', :role => roles.first})

