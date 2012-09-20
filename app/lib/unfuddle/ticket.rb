require "date"

module Unfuddle
  class Ticket
    attr_reader :id, :number, :summary, :description, :status, :priority, :assignee_id, :reporter_id

    def initialize(project_id, data, client)
      @id = data["id"]
      @number = data["number"]
      @project_id = project_id
      @client = client
      @milestone = client.milestone(project_id, data["milestone_id"])
      @summary = data["summary"] || ""
      @description = data["description"] || ""
      @status = data["status"]
      @priority = data["priority"]
      @assignee_id = data["assignee_id"]
      @reporter_id = data["reporter_id"]
      @created_at_string = data["created_at"]
      @updated_at_string = data["updated_at"]
    end

    def milestone
      @milestone ? @milestone.title : ""
    end

    def created_at
      @created_at ||= @created_at_string ? DateTime.parse(@created_at_string) : nil
    end

    def updated_at
      @updated_at ||= @updated_at_string ? DateTime.parse(@updated_at_string) : nil
    end

    def week_updated
      return "" if updated_at.nil?
      saturday = updated_at + (6 - updated_at.wday)
      saturday.strftime("%Y-%m-%d")
    end

    def to_s
      "#{status} - #{priority} - #{assignee} - #{reporter} - #{summary[0, 25]}... - #{details[0, 25]}..."
    end
  end
end
