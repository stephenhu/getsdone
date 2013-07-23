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

HOME = "/home/devops"

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
    email     = Capistrano::CLI.ui.ask("input email address: ")
    file      = "/home/devops/.ssh/id_rsa"
    public_file = "#{file}.pub"
    run "git config --global core.editor 'vi'"
    run "git config --global user.email '#{email}'"
    check = capture "if [ -f #{file} ]; then echo 'true'; fi"
    if check.empty?
      run "ssh-keygen -q -t rsa -C '#{email}' -N '' -f '#{file}'"
    end
    key = capture "cat #{public_file}"
    username  = Capistrano::CLI.ui.ask("input github username: ")
    password  = Capistrano::CLI.password_prompt("input github password: ")
    github = Github.new( login: username, password: password )
    github.users.keys.create( title: "capistrano generated", key: key )

  end

end

namespace :rbenv do

  desc "install rbenv"
  task :setup do
    check = capture "if [ -d #{HOME}/.rbenv ]; then echo 'true'; fi"
    if check.empty?
      run "git clone git@github.com:sstephenson/rbenv ~/.rbenv"
    end
    check2 = capture "grep rbenv #{HOME}/.bash_profile"
    puts "check2: #{check2}"
    if not check2.include?("rbenv")
      run "echo 'export PATH=\"#{HOME}/.rbenv/bin:$PATH\"' >> #{HOME}/.bash_profile"
      run "echo 'eval \"$(rbenv init -)\"' >> #{HOME}/.bash_profile"
    end
    check3 = capture "if [ -d #{HOME}/.rbenv/plugins/ruby-build ]; then echo 'true'; fi"
    if check3.empty?
      run "git clone git@github.com:sstephenson/ruby-build ~/.rbenv/plugins/ruby-build"
      run "exec $SHELL -l"
      run "rbenv rehash"
    end
  end
end

