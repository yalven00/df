
set :deploy_to, "/var/www/dealsformommy.com"
set :rails_env, "production"
set :user, 'deploy'

role :web, "dfm1.dealsformommy.com",  "dfm2.dealsformommy.com",  "dfm3.dealsformommy.com", "dfm4.dealsformommy.com", "dfm5.dealsformommy.com"                           # Your HTTP server, Apache/etc
role :app, "dfm1.dealsformommy.com",  "dfm2.dealsformommy.com",  "dfm3.dealsformommy.com", "dfm4.dealsformommy.com", "dfm5.dealsformommy.com"                          # This may be the same as your `Web` server
role :db,  "dfm1.dealsformommy.com", :primary => true # This is where Rails migrations will run

require "whenever/capistrano"

namespace :deploy do
  desc "Restart Resque Workers & Scheduler"
  task :restart_workers, :roles => :web do
    sudo "ls"
    #run "cd #{current_path} && sudo rake resque:restart_workers resque:restart_scheduler RAILS_ENV=production"
    run "cd #{current_path} && sudo rake resque:restart_workers RAILS_ENV=production"
  end

end

