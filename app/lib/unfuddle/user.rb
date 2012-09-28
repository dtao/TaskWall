module Unfuddle
  class User
    attr_reader :id, :username, :email

    def initialize(properties)
      @id         = properties["id"]
      @username   = properties["username"]
      @first_name = properties["first_name"]
      @last_name  = properties["last_name"]
      @email      = properties["email"]
    end

    def name
      "#{@first_name} #{@last_name}"
    end
  end
end
