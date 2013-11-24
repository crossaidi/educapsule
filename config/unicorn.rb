rails_root = ENV["ROOT_EDUCAPSULE"]

worker_processes 4

working_directory rails_root + '/current'

listen rails_root + "/current/tmp/sockets/.unicorn.sock", :backlog => 64

timeout 30

pid rails_root + "/current/tmp/pids/unicorn.pid"

stderr_path rails_root + "/shared/log/unicorn.stderr.log"
stdout_path rails_root + "/shared/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end