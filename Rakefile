require "rake"

require File.join(File.dirname(__FILE__), "config", "boot")

namespace :db do
  desc "Update the database with the latest models and associations"
  task :update do
    DataMapper.auto_upgrade!
  end

  desc "Reset the database completely"
  task :reset do
    DataMapper.auto_migrate!
  end

  desc "Import all tickets from Unfuddle into the database"
  task :import do
    Ticket.fetch_latest!
  end
end

namespace :heroku do
  desc "Upload configuration variables to Heroku"
  task :config do
    config_vars = Heroku::Config.vars_from_yaml.map do |name, value|
      "#{name}='#{value}'"
    end

    sh "heroku config:add #{config_vars.join(' ')}"
  end
end
