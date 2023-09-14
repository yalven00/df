set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

#$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_type, :system
#set :rvm_ruby_string, '1.9.2'        # Or whatever env you want it to run in.

set :application, "deals_for_mommy"
#set :deploy_via, :copy
#set :copy_cache, true

default_run_options[:pty] = true
set :scm, :git
set :ssh_options, { :forward_agent => true } 
set :repository,  "git@github.com:pmgtech/Deals-For-Mommy.git"
#set :git_shallow_clone, 1
#set :short_branch, "master"

set :whenever_command, "bundle exec whenever"

require 'capistrano_colors'
on :start do
  `ssh-add`
end

require "bundler/capistrano"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
#after "deploy:symlink", "deploy:restart_workers"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :coregs do
  task :load_seed, :roles => :db do
    run("cd #{current_path}/ && bundle exec rake db:seed", :env => {'RAILS_ENV' => rails_env})
  end
end

after "deploy:update_code", 'deploy:symlink_db_log'

#after "deploy:create_symlink", "deploy:setup_robots"

after 'deploy:restart', "deploy:setup_robots", "deploy:restart_workers"

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application} --set environment=#{stage}"
  end

  task :symlink_db_log, :roles => :app do
    run "rm #{release_path}/log"
    run "ln -s #{shared_path}/log/ #{release_path}/log"
    run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
  end

  task :setup_robots, :roles => :app do
    run "ln -s #{release_path}/public/robots/robots.txt.#{stage== :production ? 'production' : 'non_production'} #{release_path}/public/robots.txt"
  end
end

desc "tail rails log files" 
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/#{stage}.log" do |channel, stream, data|
    trap("INT") { puts 'Interupted'; exit 0; } 
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}" 
    break if stream == :err
  end
end

desc "test current dfm servers by opening new web page with each of the nodes."
task :check_nodes do
  system "open http://dfm1.dealsformommy.com"
  system "open http://dfm2.dealsformommy.com"
  system "open http://dfm3.dealsformommy.com"
  system "open http://dfm4.dealsformommy.com"
  system "open http://dfm5.dealsformommy.com"

end


