task :environment

namespace :delayed_jobs do

  desc "prep and start work"
  task :start_work => ['prep_logger', 'jobs:work']

  desc "prep logger"
  task :prep_logger => :environment do
    RAILS_DEFAULT_LOGGER = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log")
    
  end



end 


 