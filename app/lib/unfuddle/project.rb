require "json"

module Unfuddle
  class Project
    def initialize(id, client)
      @id = id
      @client = client
    end

    def each_ticket
      starting_id ||= 0
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
  end
end
