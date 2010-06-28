# Edit at your own peril - it's recommended to regenerate this file
# in the future when you upgrade to a newer version of Cucumber.

# IMPORTANT: Setting config.cache_classes to false is known to
# break Cucumber's use_transactional_fixtures method.
# For more information see https://rspec.lighthouseapp.com/projects/16211/tickets/165
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.gem 'cucumber-rails',   :lib => false, :version => '>=0.3.2' unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber-rails'))
config.gem 'database_cleaner', :lib => false, :version => '>=0.5.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/database_cleaner'))
config.gem 'capybara',         :lib => false, :version => '>=0.3.5' unless File.directory?(File.join(Rails.root, 'vendor/plugins/capybara'))
config.gem 'rspec',            :lib => false, :version => '>=1.3.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec'))
config.gem 'rspec-rails',      :lib => false, :version => '>=1.3.2' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))

# Settings specified here will take precedence over those in config/environment.rb

NODE_TIMEOUT = 30 # mins until unresponsive compute nodes are recycled

NODE_CYCLE_MAX = 3 # number of tries to recycle an unresponsive node before giving up. 
RUBY_CYCLE_MAX = 3 # number of tries to cycle the ruby process if it times out busy

#RMGR workitem queues. we may not use queues for workflows right now. 
RMGR_IN_QUEUE = 'RMGR_RQ'

HOUR_MOD = 52 # num minutes nodes are idle before they are shut off

#Temporary work directory
TEMP_DIR = "/tmp"

LOG_CMD = "" #command that prints log in the site heading.  DO NOT USE FOR TESTS

#Amazon EC2 Metadata Tool Download URL
EC2_METATOOL_URL = 'http://www.amazon.com/gp/redirect.html/ref=aws_rc_1825?location=http%3A%2F%2Fs3.amazonaws.com%2Fec2metadata%2Fec2-metadata&token=A80325AA4DAB186C80828ED5138633E3F49160D9'

#IPTABLES locations
IPTABLES_OUTPUT_PATH  = 'iptables' 
IPTABLES_RESTART_CMD = 'echo PLACEHOLDER'
IPTABLES_ERB = 'config/iptables.erb'

#Chef config locations
GIT_COOKBOOK_URL = "git@github.com:itmat/chef-repo.git"
GIT_REPOS = "chef-repo"
CHEF_BUCKET = 'itmat-chef'
CHEF_NODES_JSON_ERB = 'config/nodes.erb'
CHEF_SOLO_URL = 'http://itmat-chef.s3.amazonaws.com/solo.rb'
COOKBOOK_URL = 'http://itmat-chef.s3.amazonaws.com/adb_cook.tar.gz'

#User Data location
USER_DATA_ERB = 'config/user_data.erb'

#AWS Credentials File
AWS_CRED_PATH = 'config/aws.rb'