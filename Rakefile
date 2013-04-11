#!/usr/bin/env rake
require "active_record"
require "active_record/fixtures"
require "digest/md5"
require "logger"
#require "pg"
require "securerandom"
require "time"
require "yaml"

task :default => :help

env = ENV["RACK_ENV"] || "development"

namespace :db do

  desc "prepare environment"
  task :environment do

    @config = YAML.load_file("conf/database.yml")["#{env}"]
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
  username = ask("username: ")
  password = ask("password: ") {|q| q.echo = "*"}

  config = ERB.new(File.read("./conf/database.yml.erb"))
  contents = config.result(binding)

  file = File.open( "./conf/database.yml", "w" )
  file.write(contents)
  file.close

  puts "conf/database.yml created"

  File.chmod( 0400, file.path )

  puts "configure google oauth"
  client_id		= ask("client_id: ")
  client_secret         = ask("client_secret: ")
#TODO encrypt

  config	= ERB.new(File.read("./conf/config.yml.erb"))
  contents      = config.result(binding)

  file2 = File.open( "./conf/config.yml", "w" )
  file2.write(contents)
  file2.close

  puts "conf/config.yml created"

  File.chmod( 0400, file2.path )

  puts "configure nginx"
  root_dir = ask("root dir: ")

  config    = ERB.new(File.read("./conf/nginx.conf.erb"))
  contents  = config.result(binding)

  file3 = File.open( "./conf/nginx.conf", "w" )
  file3.write(contents)
  file3.close

  puts "conf/nginx.conf created"

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

