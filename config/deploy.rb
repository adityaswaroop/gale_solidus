require 'bundler/capistrano'
require 'rvm/capistrano'

set :rvm_autolibs_flag, 'read-only'

set :repository, 'git@github.com:adityaswaroop/gale_solidus.git'
set :scm, :git
set :branch, 'master'

set :application, "gale_solidus"
# set :deploy_via, :remote_cache
set :normalize_asset_timestamps, false
set :user, 'ubuntu'

set :deploy_to, "/opt/www/#{ application }"
set :ec2_server, 'ec2-52-66-121-241.ap-south-1.compute.amazonaws.com'
ssh_options[:keys] = '~/.ssh/aditya_pmkey.pem'
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web,  ec2_server                      # Your HTTP server, Apache/etc
role :app,  ec2_server                         # This may be the same as your `Web` server
role :db,   ec2_server, :primary => true # This is where Rails migrations will run

namespace :deploy do
  [:start, :stop].each do |t|
    desc "#{ t } task is a no-op with Phusion Passenger (mod_rails)"
    task t, roles: :app do ; end
  end


  task :create_release_dir, :except => {:no_release => true} do
    run "mkdir -p #{fetch :releases_path}"
  end

  desc 'Restarting Phusion Passenger (mod_rails) with restart.txt'
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{ File.join( current_path, 'tmp', 'restart.txt' ) }"
  end


  desc "Remove files from the web server source tree that we don't want to expose to the public"
  task :remove_sensitive_files do
    run "rm #{ release_path }/Capfile"
    run "rm #{ release_path }/config/deploy.rb"
    run "rm -r #{ release_path }/ssh"
    run "rm -r #{ release_path }/logrotate"
  end
end


namespace :capistrano_log do
  set :log_path, "#{ shared_path }/log/capistrano.log"
  set :log_timestamp, -> { Time.now.utc.strftime( '%Y-%m-%dT%H:%M:%SZ' ) }
  set :log_user_name, -> { ( name = `git config user.name`.chomp ).empty? ? '<unknown git config user.name>' : name }
  set :log_user_email, -> { ( email = `git config user.email`.chomp ).empty? ? '<unknown git config user.email>' : email }
  set :log_user, "#{ log_user_name } (#{ log_user_email })"

  namespace :deploy do
    desc 'Append deploy details to the Capistrano log file'
    task :default do
      # logs *who* deployed *what* branch and *when*
      run "echo '#{ log_timestamp }: #{ log_user } deploy branch #{ branch } from repository #{ repository }' >> #{ log_path }"
    end

    desc 'Append deploy:rollback details to the Capistrano log file'
    task :rollback do
      # logs *who* rolled back the last deployment and *when*
      run "echo '#{ log_timestamp }: #{ log_user } *** deploy:rollback ***' >> #{ log_path }"
    end
  end
end

after "deploy:setup", "deploy:create_release_dir"

after :deploy, 'deploy:migrate', 'capistrano_log:deploy'
after 'deploy:rollback', 'capistrano_log:deploy:rollback'
after 'deploy:update_code', 'deploy:remove_sensitive_files'


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end