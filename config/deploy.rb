set :application, 'educapsule'
set :repo_url, 'git@github.com:crossaidi/educapsule.git'
set :branch, 'master'

set :scm, :git

set :linked_dirs, %w{bin tmp/pids tmp/cache tmp/sockets vendor/bundle}
set :linked_files, %w{config/database.yml}

set :keep_releases, 1

set :unicorn_conf, "#{shared_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"

before 'deploy:check:linked_dirs', 'deploy:configs_upload'

namespace :deploy do

  desc 'Uploading config files to the server from local host'
  task :configs_upload do
    on roles(:all), stages: :production do
      unless test("[ -e #{shared_path}/config/ ]")
        execute :mkdir, "#{shared_path}/config"
      else
        execute :rm, "#{shared_path}/config/database.yml" if test("[ -e #{shared_path}/config/database.yml ]")
      end
      upload!("config/database_production.yml", "#{shared_path}/config/database.yml")
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do

    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do

    end
  end

  after :finishing, 'deploy:cleanup'
end