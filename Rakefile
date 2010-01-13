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
    Jeweler::GemcutterTasks.new
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end