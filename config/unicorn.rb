application = "educapsule"
deploy_to  = "/home/cross/#{application}"

rails_root = "#{deploy_to}/current"
socket_file = "#{deploy_to}/shared/sockets/.unicorn.sock"
pid_file = "#{deploy_to}/shared/pids/unicorn.pid"
error_log_file = "#{rails_root}/log/unicorn.stderr.log"
output_log_file = "#{rails_root}/log/unicorn.stdout.log"
old_pid    = "#{pid_file}.oldbin"

working_directory rails_root

listen socket_file, :backlog => 64
pid pid_file

stderr_path error_log_file
stdout_path output_log_file

timeout 30
worker_processes 4

preload_app true

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{rails_root}/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end