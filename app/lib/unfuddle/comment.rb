require "date"

module Unfuddle
  class Comment
    attr_reader :id, :ticket_id, :user_id, :body

    def initialize(data)
      @id                = data["id"]
      @ticket_id         = data["parent_id"]
      @user_id           = data["author_id"]
      @body              = data["body"]
      @created_at_string = data["created_at"]
      @updated_at_string = data["updated_at"]
    end

    def created_at
      @created_at ||= @created_at_string ? DateTime.parse(@created_at_string) : nil
    end

    def updated_at
      @updated_at ||= @updated_at_string ? DateTime.parse(@updated_at_string) : nil
    end
  end
end
