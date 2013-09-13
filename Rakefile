#!/usr/bin/env rake
require "active_record"
require "active_record/fixtures"
require "digest/md5"
require "logger"
require "pg"
require "securerandom"
require "sinatra/activerecord/rake"
require "time"
require "yaml"

task :default => :help

env = ENV["RACK_ENV"] || "development"

namespace :db do

  desc "prepare environment"
  task :environment do

    @config = YAML.load_file("config/database.yml")["#{env}"]
    ActiveRecord::Base.establish_connection @config

  end

  desc "migrate database"
  task :migrate => :environment do

    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")

  end

  desc "seed fixtures"
  task :seed => :environment do

    Dir.glob( "db/fixtures/*.yml").each do |f|

      ActiveRecord::Fixtures.create_fixtures( "db/fixtures",
        File.basename( f, ".*" ) )

    end

  end


end

desc "configuration"
task :config do

  require "highline/import"
  require "erb"

  file = File.dirname(__FILE__) + "/db/getsdone.db"

  puts "configure postgresql"
  #username = ask("username: ")
  #password = ask("password: ") {|q| q.echo = "*"}

  config = ERB.new(File.read("./config/database.yml.erb"))
  contents = config.result(binding)

  file = File.open( "./config/database.yml", "w" )
  file.write(contents)
  file.close

  puts "config/database.yml created"

  File.chmod( 0400, file.path )

  #puts "configure google oauth"
  #client_id		= ask("client_id: ")
  #client_secret         = ask("client_secret: ")
#TODO encrypt

  puts "configure app"
  app_key = ask("cipher key: ")
  app_iv  = ask("cipher iv: ")
#TODO check length

  puts "configure api"
  api_key = ask("api key: ")

  config	= ERB.new(File.read("./config/config.yml.erb"))
  contents      = config.result(binding)

  file2 = File.open( "./config/config.yml", "w" )
  file2.write(contents)
  file2.close

  puts "config/config.yml created"

  File.chmod( 0400, file2.path )

  puts "configure nginx"
  root_dir  = ask("root dir: ")
  nginx_dir = ask("nginx root dir: ")

  config    = ERB.new(File.read("./config/nginx.conf.erb"))
  contents  = config.result(binding)

  file3 = File.open( "./config/nginx.conf", "w" )
  file3.write(contents)
  file3.close

  puts "config/nginx.conf created"

  File.chmod( 0400, file3.path )
   
end

desc "generate help text"
task :help do

  puts "rake"
  puts "  config"
  puts "  db:create"
  puts "  db:migrate"
  puts "  db:seed"

end

