namespace :prep do
  desc "Do all prep tasks"
  task :all => ['db', 'ami_ids', 'elastic_ip', 'delayed_jobs:start_work']

  desc "Start the start_work delayed job"
  task :start_work => :environment do
    Delayed::Worker.new.start
  end

  desc "Drop, Migrate, Seed the database"
  task :db => ['db:drop', 'db:create', 'db:migrate', 'db:seed']
  
  desc "Set the elastic IP that points to our hostname back to this instance"
  task :elastic_ip => :environment do
    require "right_aws"
    META_URL = 'http://169.254.169.254/latest/meta-data/instance-id' 
    resp = Net::HTTP.get_response(URI.parse(META_URL))
    instance_id = resp.body
    @right_aws_ec2 = RightAws::Ec2.new(AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY)
    @right_aws_ec2.associate_address(instance_id, AWS_WWW_ELASTIC_IP)
  end
  
  desc "Changes the AMI ID to that of the current AWS Web Server in the DB"
  task :ami_ids => :environment do
    Role.destroy_all
    Role.find_or_create_by_name(:name => "general", :description => "General empty role", :platform => "aki", :recipes => "")
    Role.find_or_create_by_name(:name => "basic", :description => "Basic role for compute nodes", :platform => "aki", :recipes => "qips-node")
    
    Farm.destroy_all
    result_www = Farm.find_or_create_by_name(:name => 'WWW', :description => 'AWS Web Server', :ami_id => WWW_AMI_ID, :min => 0, :max => 1, :role => Role.find_by_name("general"), :key_pair_name => 'admin-systems', :security_groups => 'www-prod', :farm_type => 'admin', :ami_spec => 'c1.medium', :spot_price => 0.5.to_f)
    result_32 = Farm.find_or_create_by_name(:name => 'Compute Node 32-bit', :description => 'AWS Compute Node - 32-bit', :ami_id => COMPUTE32_AMI_ID, :min => 0, :max => 1, :role => Role.find_by_name("basic"), :key_pair_name => 'admin-systems', :security_groups => 'compute-prod', :farm_type => 'compute', :ami_spec => 'c1.medium', :spot_price => 0.5.to_f)
    result_64 = Farm.find_or_create_by_name(:name => 'Compute Node 64-bit', :description => 'AWS Compute Node - 64-bit', :ami_id => COMPUTE64_AMI_ID, :min => 0, :max => 1, :role => Role.find_by_name("basic"), :key_pair_name => 'admin-systems', :security_groups => 'compute-prod', :farm_type => 'compute', :ami_spec => 'm1.large', :spot_price => 1.0.to_f)
    Farm.update(result_www[:id], {:ami_id => WWW_AMI_ID})
    Farm.update(result_32[:id], {:ami_id => COMPUTE32_AMI_ID})
    Farm.update(result_64[:id], {:ami_id => COMPUTE64_AMI_ID})
    
    Instance.destroy_all   
  end
end