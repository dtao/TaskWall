require "active_support/core_ext"
require "httparty"

%w{user project milestone ticket}.each do |model|
  require File.join(File.dirname(__FILE__), model)
end

module Unfuddle
  class Client
    include HTTParty

    class << self
      def load_from_yaml(path)
        new(YAML.load_file(path))
      end
    end

    def initialize(config)
      config = config.stringify_keys

      @subdomain = config["subdomain"]
      @username = config["username"]
      @password = config["password"]
    end

    def project(id)
      projects[id] ||= Project.new(id, self)
    end

    def user(id)
      users[id] ||= User.find(id, self)
    end

    def milestone(project_id, id)
      milestones["#{project_id}_#{id}"] ||= Milestone.find(project_id, id, self)
    end

    def new_ticket(project_id, data)
      Ticket.new(project_id, data, self)
    end

    def fetch(route, params=nil)
      options = params ? options_for_auth.merge(:query => params) : options_for_auth
      yield Client.get("https://#{@subdomain}.unfuddle.com/api/v1/#{route}.json", options)
    end

    private
    def options_for_auth
      { :basic_auth => { :username => @username, :password => @password } }
    end

    def projects
      @projects ||= {}
    end

    def milestones
      @milestones ||= {}
    end

    def users
      @users ||= {}
    end
  end
end
