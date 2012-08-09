module Unfuddle
  class User
    class << self
      def find(id, client)
        begin
          client.fetch("people/#{id}") do |response|
            new(JSON.parse(response.body))
          end
        rescue
          null_user
        end
      end

      def null_user
        @null_user ||= new({
          "username" => "[deleted]",
          "first_name" => "[deleted]",
          "last_name" => "[deleted]",
          "email" => "[deleted]"
        })
      end
    end

    def name
      "#{@first_name} #{@last_name}"
    end

    private
    def initialize(properties)
      @username = properties["username"]
      @first_name = properties["first_name"]
      @last_name = properties["last_name"]
      @email = properties["email"]
    end
  end
end
