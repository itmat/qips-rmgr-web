# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'



begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "qips-rmgr-web"
    gemspec.summary = "Web-based resource manager for QIPS suite."
    gemspec.description = "Works with qips node to manage aws instances based on demand."
    gemspec.email = "daustin@mail.med.upenn.edu"
    gemspec.homepage = "http://github.com/abrader/qips-rmgr-web"
    gemspec.authors = ["David Austin", "Andrew Brader"]
    gemspec.add_dependency "erubis", ">=2.6.2"
    gemspec.add_dependency "json", ">=1.2.0"
    gemspec.add_dependency "amazon-ec2", "=0.9.3"
    gemspec.add_dependency "right_aws", ">=1.10.0"
    gemspec.add_dependency "mysql", ">=2.1.0"
    gemspec.add_dependency "octopussy", ">=0.2.2"
    gemspec.add_dependency "git", ">=1.2.5"
    gemspec.add_dependency "archive-tar-minitar", ">=0.5.2"
    gemspec.add_dependency "delayed_job", "=2.0.3"
    gemspec.add_dependency "whenever", ">=0.5.0"
    gemspec.add_dependency "ohai", ">=0.5.6"

    gemspec.add_development_dependency 'rspec-rails', '>= 1.3.2'
    gemspec.add_development_dependency "rspec", ">=1.2.9"
    gemspec.add_development_dependency "cucumber", ">=0.4.3"
    gemspec.add_development_dependency "pickle", ">=0.1.21"
    gemspec.add_development_dependency 'cucumber-rails', '>=0.3.0'
    gemspec.add_development_dependency 'database_cleaner', '>=0.5.0' 
    gemspec.add_development_dependency 'webrat', '>=0.7.0'
    gemspec.add_development_dependency "capybara", "=0.3.8"
    gemspec.add_development_dependency "thoughtbot-factory_girl", ">=1.2.1"

    gemspec.require_path = 'lib'
    gemspec.rubyforge_project = "nowarning"
    Jeweler::GemcutterTasks.new
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
