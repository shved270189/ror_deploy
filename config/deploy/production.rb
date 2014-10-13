set :rvm_ruby_string, '2.1.2'
set :rvm_bin_path, '/home/ror/.rvm/bin'

set :application, "ror_test"
set :rails_env, "production"
set :domain, "ror@178.62.192.203"

role :web, domain
role :app, domain
role :db, domain, :primary => true

set :deploy_to, "/home/ror/#{application}"

set :branch, "master"

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"