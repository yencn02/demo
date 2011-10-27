set :application,    "vafitness"

# git
set :scm,           :git
#set :repository,    "git@github-endax:endax/client-vafitness.git"
set :repository,    "git@github.com:endax/client-vafitness.git"

# server
set :deploy_via,    :remote_cache
set :keep_releases, 5

#authentication
set  :user,         "jbresnik"
#set  :password,     "xxxxx"
set  :domain,       'llnw.net'

set  :rake,         "/opt/ruby-enterprise-1.8.7-2010.02/bin/rake"

default_run_options[:pty]   = true
ssh_options[:user]          = "jbresnik"
ssh_options[:keys]          = ["#{ENV['HOME']}/.ssh/id_rsa"]

#environments
task :production do
  set  :deploy_to,    '/opt/vafitness'
  set  :branch,       'master'
  set  :rails_env,    'production'
  role :web,          'vafit-app1.cust.phx2.llnw.net', 'vafit-app2.cust.phx2.llnw.net'
  role :app,          'vafit-app1.cust.phx2.llnw.net', 'vafit-app2.cust.phx2.llnw.net'
  role :db,           'vafit-app1.cust.phx2.llnw.net', :primary => true
end

task :staging do
  set  :rails_env,    'staging'
  set  :deploy_to,    '/opt/vafitness-staging'
  set  :branch,       'master'
  set  :rails_env,    'staging'
  role :web,          'vafit-app1.cust.phx2.llnw.net', 'vafit-app2.cust.phx2.llnw.net'
  role :app,          'vafit-app1.cust.phx2.llnw.net', 'vafit-app2.cust.phx2.llnw.net'
  role :db,           'vafit-app1.cust.phx2.llnw.net', :primary => true
end

namespace :vafitness do
  desc 'Update the symlinks'
  task :symlink, :roles => :app do
    run <<-CMD
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml;
      ln -nfs #{shared_path}/config/gmaps_api_key.yml #{release_path}/config/gmaps_api_key.yml;
    CMD
  end
end

# overide default restart
namespace :deploy do
  task :restart do
     run "touch #{current_path}/tmp/restart.txt"
  end
end

# hooks
after  "deploy:update_code", "vafitness:symlink"
after  "deploy:update",      "deploy:cleanup"
