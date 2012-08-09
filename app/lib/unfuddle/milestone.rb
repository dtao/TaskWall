module Unfuddle
  class Milestone
    class << self
      def find(project_id, id, client)
        begin
          client.fetch("projects/#{project_id}/milestones/#{id}") do |response|
            new(JSON.parse(response.body))
          end
        rescue
          null_milestone
        end
      end

      def null_milestone
        @null_milestone ||= new({
          "title" => "[deleted]"
        })
      end
    end

    attr_reader :title

    private
    def initialize(properties)
      @title = properties["title"]
    end
  end
end
