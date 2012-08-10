require "rake"
require "yaml"

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
end

namespace :heroku do
  desc "Upload configuration variables to Heroku"
  task :config do
    config = YAML.load_file(File.join(PADRINO_ROOT, "config", "heroku.yml"))
    config_vars = config.map do |name, subvars|
      subvars.map do |key, value|
        "#{name}_#{key}='#{value}'".upcase
      end
    end.flatten.join(" ")

    sh "heroku config:add #{config_vars}"
  end
end
