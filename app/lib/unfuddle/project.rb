require "json"

module Unfuddle
  class Project
    def initialize(id, client)
      @id = id
      @client = client
    end

    def all_users
      users = []

      @client.fetch("projects/#{@id}/people", { :limit => 100 }) do |response|
        begin
          results = JSON.parse(response.body)

          results.each do |data|
            users << User.new(data)
          end

        rescue => e
          puts "An exception occurred: #{e.message}"
        end
      end

      users
    end

    def each_ticket
      starting_id = 0
      finished = false
      page = 1

      until finished
        @client.fetch("projects/#{@id}/tickets", { :limit => 100, :page => page }) do |response|
          begin
            results = JSON.parse(response.body)

            if results.empty?
              finished = true
              break
            end

            results.each do |data|
              ticket = @client.new_ticket(@id, data)

              if !(yield ticket)
                finished = true
                break
              end
            end

          rescue => e
            puts "An exception occurred: #{e.message}"
            break

          ensure
            page += 1
          end
        end
      end
    end

    def each_comment(since)
      options = {
        :start_date => since.strftime("%Y/%m/%d"),
        :end_date   => (Time.now + 1.day).strftime("%Y/%m/%d")
      }

      @client.fetch("projects/#{@id}/tickets/comments", options) do |response|
        begin
          results = JSON.parse(response.body)

          results.each do |data|
            next unless data["parent_type"] == "Ticket"
            comment = @client.new_comment(data)

            break if !(yield comment)
          end

        rescue => e
          puts "An exception occurred: #{e.message}"
        end
      end
    end
  end
end
