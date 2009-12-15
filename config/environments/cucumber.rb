# Settings specified here will take precedence over those in config/environment.rb

NODE_TIMEOUT = 30 # mins until unresponsive compute nodes are recycled

NODE_CYCLE_MAX = 3 # number of tries to recycle an unresponsive node before giving up. 
RUBY_CYCLE_MAX = 3 # number of tries to cycle the ruby process if it times out busy

#RMGR workitem queues. we may not use queues for workflows right now. 
RMGR_IN_QUEUE = 'RMGR_RQ'

HOUR_MOD = 52 # num minutes nodes are idle before they are shut off

IPTABLES_OUTPUT_PATH  = 'iptables' 
IPTABLES_RESTART_CMD = 'echo PLACEHOLDER'
IPTABLES_ERB = 'config/iptables.erb'


LOG_CMD = "" #command that prints log in the site heading.  DO NOT USE FOR TESTS


config.cache_classes = true # This must be true for Cucumber to operate correctly!

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

config.gem 'cucumber',    :lib => false,        :version => '>=0.3.102' unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber'))
config.gem 'webrat',      :lib => false,        :version => '>=0.5.0' unless File.directory?(File.join(Rails.root, 'vendor/plugins/webrat'))
config.gem 'rspec',       :lib => false,        :version => '>=1.2.8' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec'))
config.gem 'rspec-rails', :lib => false,        :version => '>=1.2.7.1' unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))

