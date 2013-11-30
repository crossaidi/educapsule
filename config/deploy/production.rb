set :stage, :production

set :host, ENV['EDUCAPSULE_PROD_HOST']
set :port, ENV['EDUCAPSULE_PROD_PORT']
set :user, ENV['EDUCAPSULE_PROD_USER']

server fetch(:host), port: fetch(:port), user: fetch(:user), roles: %w{web app db}

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

set :rvm_type, :user
set :bundle_flags, '--deployment'
set :bundle_without, %w{development test}.join(' ')
