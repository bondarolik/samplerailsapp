# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "sampleapp"
set :repo_url, "git@github.com:bondarolik/samplerailsapp.git"
set :user, "deploy"

set :rbenv_type, :user
set :rbenv_ruby, '3.0.3'

set :passenger_restart_with_touch, true
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

set :keep_releases, 5

append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'