require "github_api"

set :application, "getsdone"
set :scm, :git
set :repository,  "git@github.com:stephenhu/getsdone"
set :deploy_to, "/web/#{application}"
set :use_sudo, false
set :ssh_options, {:forward_agent => true}
default_run_options[:pty] = true

set :user, "devops"
set :group, user
set :runner, user

set :host, "#{user}@192.168.176.135"
role :web, host
role :app, host
role :db,  host

set :rails_env, :production

namespace :postgresql do
  desc "create database"
  task :create, roles: :db do
    run "psql -U postgres -W -c 'create database getsdone'"
  end
end

namespace :ubuntu do

  desc "install common packages"
  task :setup do

    pkgs = %w(git gcc make zlib1g-dev libxml2-dev libxml2 libxslt1.1 libxslt1-dev openssl libssl-dev g++ unzip sqlite3 libsqlite3-dev libpq-dev ntp libpcre3 libpcre3-dev)
    run "#{sudo} apt-get update -y"
    pkgs.each do |pkg|
      puts %{pkg}
      run "#{sudo} apt-get install #{pkg} -y"
    end

  end

end

namespace :github do

  desc "configure github environment"
  task :setup do
    email = Capistrano::CLI.ui.ask("input email address: ")
    #run "git config --global core.editor 'vi'"
    #run "git config --global user.email '#{email}'"
    file      = Capistrano::CLI.ui.ask("input public key path: ")
    run "ssh-keygen -t rsa -C '#{email}' -N '' -f '#{file}'"
    #file = "/home/devops/.ssh/basic"
    public_file = "#{file}.pub"
    key = capture "cat #{public_file}"
    #username  = Capistrano::CLI.ui.ask("input github username: ")
    #run "curl -i -u #{username}:fuckyou1 -X POST -d '#{json}' https://api.github.com/user/keys"
    github = Github.new( login: "stephenhu", password: "fuckyou1" )

    github.users.keys.create( title: "capistrano generated", key: key )
  
  end

end

namespace :ruby do

  desc "install rbenv"
  task :git do
  end

end

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

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
