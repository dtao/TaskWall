class Ticket
  include DataMapper::Resource

  belongs_to :user

  property :id,          Serial
  property :user_id,     Integer
  property :unfuddle_id, Integer
  property :summary,     String
  property :description, Text
  property :status,      String
  property :updated_at,  DateTime
  property :estimate,    Decimal

  def self.fetch_latest
    latest_id = self.max(:unfuddle_id) || 0
    puts "Highest Unfuddle ID in the system currently: #{latest_id || 'nil'}"

    client = Unfuddle::Client.load_from_yaml(File.join(PADRINO_ROOT, "config", "unfuddle.yml"))
    project = client.project(1)

    project.each_ticket do |t|
      if t.id <= latest_id
        puts "Already caught up to most recent ticket. Quitting."
        false

      else
        ticket = self.first(:unfuddle_id => t.id)

        if ticket.nil?
          ticket = self.create({
            :user_id => User.first_or_create(:name => t.assignee).id,
            :unfuddle_id => t.id,
            :summary => t.summary,
            :description => t.description,
            :status => t.status,
            :updated_at => t.updated_at
          })

        else
          puts "Ticket #{ticket.unfuddle_id} already exists!"
        end

        true
      end
    end
  end
end
