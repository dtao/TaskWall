require "json"

module Unfuddle
  class Project
    def initialize(id, client)
      @id = id
      @client = client
    end

    def tickets
      @client.fetch("projects/#{@id}/tickets") do |response|
        JSON.parse(response.body).map { |data| @client.new_ticket(@id, data) }
      end
    end
  end
end
