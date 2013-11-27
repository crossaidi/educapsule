set :application, 'educapsule'
set :repo_url, 'git@github.com:crossaidi/educapsule.git'
set :branch, 'master'

set :scm, :git

set :bundle_gemfile, -> { release_path.join('Gemfile') }

set :linked_dirs, %w{bin tmp/pids tmp/cache tmp/sockets vendor/bundle}
#set :linked_files, %w{config/database.yml.sample}

set :keep_releases, 5

namespace :deploy do

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