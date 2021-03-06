# Settings specified here will take precedence over those in config/environment.rb

NODE_TIMEOUT = 30 # mins until unresponsive compute nodes are recycled

NODE_CYCLE_MAX = 3 # number of tries to recycle an unresponsive node before giving up. 
RUBY_CYCLE_MAX = 3 # number of tries to cycle the ruby process if it times out busy

#RMGR workitem queues. we may not use queues for workflows right now. 
RMGR_IN_QUEUE = 'RMGR_RQ'

HOUR_MOD = 52 # num minutes nodes are idle before they are shut off

#Temporary work directory
TEMP_DIR = "/tmp"

#Amazon EC2 Metadata Tool Download URL
EC2_METATOOL_URL = 'http://s3.amazonaws.com/ec2metadata/ec2-metadata'

#IPTABLES locations
IPTABLES_OUTPUT_PATH  = 'iptables' 
IPTABLES_RESTART_CMD = 'echo PLACEHOLDER'
RPM_IPTABLES_ERB = 'config/rpm_iptables.erb'
DEB_IPTABLES_ERB = 'config/deb_iptables.erb'

#Chef config locations
GIT_COOKBOOK_URL = "git@github.com:itmat/chef-repo.git"
GIT_REPOS = "chef-repo"
CHEF_BUCKET = 'itmat-chef'
CHEF_NODES_JSON_ERB = 'config/nodes.erb'
CHEF_SOLO_URL = 'http://itmat-chef.s3.amazonaws.com/solo.rb'
COOKBOOK_URL = 'http://itmat-chef.s3.amazonaws.com/adb_cook.tar.gz'

# Amazon AMI IDs for farms
WWW_AMI_ID = 'ami-69987600'
COMPUTE32_AMI_ID = 'ami-17f51c7e'
COMPUTE64_AMI_ID = 'ami-eff51c86'

#User Data location
USER_DATA_ERB = 'config/user_data.erb'

#AWS Credentials File
AWS_CRED_PATH = 'config/aws.rb'

LOG_CMD = "tail -500 ./log/#{RAILS_ENV}.log" #command that prints log in the site heading.  DO NOT USE FOR TESTS


# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.gem 'rspec-rails', :version => '>= 1.3.2', :lib => false unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
config.gem "rspec", :lib => false, :version => ">=1.2.9"
config.gem "cucumber", :lib => false, :version => ">=0.4.3"
config.gem "pickle", :lib => false, :version => ">=0.1.21"
config.gem 'cucumber-rails',   :lib => false, :version => '>=0.3.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber-rails'))
config.gem 'database_cleaner', :lib => false, :version => '>=0.5.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/database_cleaner'))
config.gem 'webrat',           :lib => false, :version => '>=0.7.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/webrat'))
config.gem "capybara", :lib => false, :version => "=0.3.8"
config.gem "erubis", :lib => false, :version => ">=2.6.2"
config.gem "json", :lib => false, :version => ">=1.2.0"
config.gem "amazon-ec2",  :lib => false, :version => ">=0.9.3"
config.gem "right_aws", :lib => false, :version => ">=1.10.0"
config.gem "octopussy", :lib => false, :version => ">=0.2.2"
config.gem "git", :lib => false, :version => ">=1.2.5"
config.gem "archive-tar-minitar", :lib => false, :version => ">=0.5.2"
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
