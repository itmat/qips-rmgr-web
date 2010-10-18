RAILS_ROOT = "/usr/lib/ruby/gems/1.8/gems/qips-rmgr-web-0.6.1"

God.watch do |w|
  w.dir = RAILS_ROOT
  w.name = "qips-rmgr-delayed-job"
  w.env = { 'RAILS_ROOT' => RAILS_ROOT,'RAILS_ENV' => "production" }
  w.interval = 30.seconds
  w.start = "/usr/bin/rake prep:start_work"
  w.stop = "ps -eo pid,command | grep -i start_work | grep -iv grep | awk '{print $1}' | xargs kill -9"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  #w.pid_file = "#{RAILS_ROOT}/log/rmgr_delayed_job.pid"
  w.log = "#{RAILS_ROOT}/log/god.log"
  w.uid = 'www-data'
  w.gid = 'www-data'

  w.behavior(:clean_pid_file)

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.notify = 'Andrew'
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.notify = 'Andrew'
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      c.notify = 'Andrew'
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
      c.notify = 'Andrew'
    end
  end
end
