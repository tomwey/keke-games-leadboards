require "bundler/capistrano"

server "112.124.48.51", :web, :app, :db, primary: true

set :application, "keke-games-leaderboards"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository,  "git@github.com:tomwey/keke-games-leadboards.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# 保留5个最新的版本
after "deploy", "deploy:cleanup"
# after "deploy:cleanup", "deploy:remote_rake"

namespace :deploy do
    
  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"
  
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    # run "ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
  
  task :remote_rake, roles: :db do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:migrate"
  end
  # desc "Make sure local git is in sync with remote."
  # task :check_revision, roles: :web do
  #   unless `git rev-parse HEAD` == `git rev-parse origin/master` do
  #     puts "WARNING: HEAD is not the same as origin/master"
  #     puts "Run `git push` to sync changes."
  #     exit
  #   end
  # end
  # before "deploy", "deploy:check_revision"
end

namespace :remote_rake do
  task :create do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:create"
  end
  task :migrate do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:migrate"
  end
  task :drop do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:drop"
  end
end
