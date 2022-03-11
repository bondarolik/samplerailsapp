server "64.227.102.88", user: 'deploy', roles: %w{app db web}
set :branch, "staging"
set :deploy_to, "/home/deploy/#{fetch :application}"
set :rails_env, 'production'
