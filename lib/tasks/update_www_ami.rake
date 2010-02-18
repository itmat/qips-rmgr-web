namespace :update_ami do
  desc "Changes the AMI ID to that of the current AWS Web Server in the DB"
  task :find => :environment do
    path = "/opt/bin"
    if File.exists?(path) and File.directory?(path) and File.exists?("#{path}/farm_ami_ids.yml")
      yml = YAML.load_file("#{path}/farm_ami_ids.yml")
      www_ami_id = yml['www_ami_id']
      compute_ami_id = yml['compute_ami_id']
      result = Farm.find_or_create_by_name(:name => 'WWW', :description => 'AWS Web Server', :ami_id => www_ami_id, :min => 0, :max => 1, :role_id => 2, :key_pair_name => 'admin-systems', :security_groups => 'www-prod', :farm_type => 'admin', :kernel_id => '', :default_user_data => '')
      puts Farm.find(:all).each do |sucker|
        puts sucker
      end
    end
  end
end