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

config.gem "rspec", :lib => false, :version => ">=1.2.2"
config.gem "rspec-rails", :lib => false, :version => ">=1.2.2"
config.gem "webrat", :lib => false, :version => ">=0.4.3"
config.gem "cucumber", :lib => false, :version => ">=0.3.0"
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
config.gem "erubis", :lib => false, :version => ">=2.6.2"
config.gem "json", :lib => false, :version => ">=1.2.0"
config.gem "amazon-ec2",  :lib => false, :version => ">=0.9.3"