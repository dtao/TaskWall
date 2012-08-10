# Define our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path("../..", __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require "rubygems" unless defined?(Gem)
require "bundler/setup"
Bundler.require(:default, PADRINO_ENV)

##
# Enable devel logging
#
Padrino::Logger::Config[:development][:log_level]  = :devel
Padrino::Logger::Config[:development][:log_static] = true

##
# Add your before load hooks here
#
Padrino.before_load do
end

##
# Add your after load hooks here
#
Padrino.after_load do
  DataMapper.finalize

  if Padrino.env == :development
    Heroku::Config.vars_from_yaml.each do |name, value|
      ENV[name] = value
    end
  end

  # Download any new tickets via the Unfuddle API - temporarily disabling this.
  # Ticket.fetch_latest! unless Padrino.env == :development
end

Padrino.load!
