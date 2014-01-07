deploy_to  = ENV['EDUCAPSULE_ROOT']
rails_root = "#{deploy_to}/current"
socket_file = "#{deploy_to}/shared/tmp/sockets/.unicorn.sock"
pid_file = "#{deploy_to}/shared/tmp/pids/unicorn.pid"
old_pid    = pid_file + '.oldbin'
error_log_file = "#{rails_root}/log/unicorn.stderr.log"
output_log_file = "#{rails_root}/log/unicorn.stdout.log"

listen socket_file, backlog: 64

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
      #Process.kill("QUIT", File.read(old_pid).to_i) if File.exists?(old_pid) && server.pid != old_pid
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end