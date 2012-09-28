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

    def initialize(config = {})
      @subdomain = config[:subdomain] || ENV["UNFUDDLE_SUBDOMAIN"]
      @username  = config[:username]  || ENV["UNFUDDLE_USERNAME"]
      @password  = config[:password]  || ENV["UNFUDDLE_PASSWORD"]
    end

    def project(id)
      projects[id] ||= Project.new(id, self)
    end

    def milestone(project_id, id)
      milestones["#{project_id}_#{id}"] ||= Milestone.find(project_id, id, self)
    end

    def new_ticket(project_id, data)
      Ticket.new(project_id, data, self)
    end

    def new_comment(data)
      Comment.new(data)
    end

    def fetch(route, params=nil)
      options = params ? options_for_auth.merge(:query => params) : options_for_auth
      yield Client.get("https://#{@subdomain}.unfuddle.com/api/v1/#{route}.json", options)
    end

    def post(route, body=nil)
      options = body ? options_for_post.merge(:body => body) : options_for_post
      yield Client.post("https://#{@subdomain}.unfuddle.com/api/v1/#{route}.xml", options)
    end

    def put(route, body=nil)
      options = body ? options_for_post.merge(:body => body) : options_for_post
      yield Client.put("https://#{@subdomain}.unfuddle.com/api/v1/#{route}.xml", options)
    end

    private
    def options_for_post
      options_for_auth.merge(:headers => { "Content-Type" => "application/xml" })
    end

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
