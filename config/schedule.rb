# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
require 'ip_access_writer'

every 1.minute do
  os = IpAccessWriter.os_type()
  if os == 'rpm'
    command "/sbin/service iptables restart > /dev/null 2>&1"
  elsif os == 'debian'
    command "/usr/bin/env sh /tmp/iptables-saved" 
  else
    # Do nothing for OS's we currently don't support
  end
end

every :reboot do
  rake "prep:db"
  rake "prep:ami_ids"
  #rake "prep:all"  # Enable this when you tested the others well enough.
end