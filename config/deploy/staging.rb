
set :deploy_to, "/var/www/staging.dealsformommy.com"
set :rails_env, "staging"
set :user, 'deploy'

role :web, "staging.dealsformommy.com"                          # Your HTTP server, Apache/etc
role :app, "staging.dealsformommy.com"                          # This may be the same as your `Web` server
role :db,  "staging.dealsformommy.com", :primary => true # This is where Rails migrations will run

namespace :deploy do
  desc "Restart Resque Workers & Scheduler"
  task :restart_workers, :roles => :web do
    #run_remote_rake "resque:restart_workers"
    run "cat ~/.pw"
    sudo "ls"
    #run "cd #{current_path} && sudo rake resque:restart_workers resque:restart_scheduler RAILS_ENV=staging"
    run "cd #{current_path} && sudo rake resque:restart_workers RAILS_ENV=staging"
  end
end

