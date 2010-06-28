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
    path = "/opt/bin"
    if File.exists?(path) and File.directory?(path) and File.exists?("#{path}/farm_ami_ids.yml")
      yml = YAML.load_file("#{path}/farm_ami_ids.yml")
      
      #One for the WWW Farm to get the latest ami_id
      www_ami_id = yml['www_ami_id']
      result = Farm.find_or_create_by_name(:name => 'WWW', :description => 'AWS Web Server', :ami_id => www_ami_id, :min => 0, :max => 1, :role_id => 2, :key_pair_name => 'admin-systems', :security_groups => 'www-prod', :farm_type => 'admin', :kernel_id => '', :default_user_data => '')
      Farm.update(result[:id], {:ami_id => www_ami_id})
      
      #And the other for the Compute Node Farm to get it's latest ami_id
      compute_ami_id = yml['compute_ami_id']
      compute_aki_id = yml['compute_aki_id']
      if (compute_aki_id.nil? || compute_aki_id.empty?)
        result = Farm.find_or_create_by_name(:name => 'Compute Node', :description => 'AWS Compute Node', :ami_id => compute_ami_id, :min => 0, :max => 1, :role_id => 2, :key_pair_name => 'admin-systems', :security_groups => 'compute-prod', :farm_type => 'compute', :kernel_id => '', :default_user_data => '')
      else
        result = Farm.find_or_create_by_name(:name => 'Compute Node', :description => 'AWS Compute Node', :ami_id => compute_ami_id, :min => 0, :max => 1, :role_id => 2, :key_pair_name => 'admin-systems', :security_groups => 'compute-prod', :farm_type => 'compute', :kernel_id => compute_aki_id, :default_user_data => '')
      end
      Farm.update(result[:id], {:ami_id => compute_ami_id})     
    end
  end
end