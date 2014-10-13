require 'rvm/capistrano'
require 'bundler/capistrano'

set :stages, %w(production)
set :default_stage, 'production'

require 'capistrano/ext/multistage'

set :rvm_type, :user
set :rvm_install_with_sudo, false

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :use_sudo, false

set :scm, :git
set :repository, 'git@github.com:shved270189/ror_deploy.git'

set :deploy_via, :remote_cache

before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby'

after 'deploy:finalize_update', :roles => :app do
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"

  run "rm -f #{current_release}/config/secrets.yml"
  run "ln -s #{deploy_to}/shared/config/secrets.yml #{current_release}/config/secrets.yml"
end

after 'deploy:restart', 'unicorn:restart'
after 'deploy:start', 'unicorn:start'
after 'deploy:stop', 'unicorn:stop'

namespace :unicorn do
  task :restart do
    stop
    start
    # run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
