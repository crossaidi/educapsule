rails_root = ENV['EDUCAPSULE_ROOT_LOCAL']
socket_file = "#{rails_root}/tmp/sockets/.unicorn.sock"
pid_file = "#{rails_root}/tmp/pids/unicorn.pid"
error_log_file = "#{rails_root}/log/unicorn.stderr.log"
output_log_file = "#{rails_root}/log/unicorn.stdout.log"

listen socket_file, :backlog => 64
listen '8888'

pid pid_file
stderr_path error_log_file
stdout_path output_log_file

timeout 30
worker_processes 4

preload_app true

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end