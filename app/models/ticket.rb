class Ticket
  include DataMapper::Resource

  belongs_to :user
  has n, :updates, "TicketUpdate"

  property :id,                  Serial
  property :unfuddle_id,         Integer

  # Duplicate properties
  property :user_id,             Integer
  property :summary,             String
  property :description,         Text
  property :status,              String
  property :estimate,            Decimal
  property :created_at,          DateTime
  property :updated_at,          DateTime
  property :unfuddle_created_at, DateTime
  property :unfuddle_updated_at, DateTime

  def self.closed_or_resolved
    self.all(:status => ["closed", "resolved"])
  end

  def self.fetch_latest!(since=nil)
    client = Unfuddle::Client.new
    project = client.project(1)

    since ||= Time.now.utc - 3.months

    project.each_ticket do |unfuddle_ticket|
      ticket = self.first(:unfuddle_id => unfuddle_ticket.id)

      if ticket.nil?
        # Only create new records for recent tickets.
        if (unfuddle_ticket.updated_at || unfuddle_ticket.created_at) < since
          puts "Quitting at Unfuddle ticket #{unfuddle_ticket.id} (too old)"
          break false
        end

        ticket = self.create({
          :unfuddle_id         => unfuddle_ticket.id,
          :user                => User.first_or_create(:name => unfuddle_ticket.assignee),
          :summary             => unfuddle_ticket.summary,
          :description         => unfuddle_ticket.description,
          :status              => unfuddle_ticket.status,
          :unfuddle_created_at => unfuddle_ticket.created_at,
          :unfuddle_updated_at => unfuddle_ticket.updated_at
        })

        puts "Created ticket #{ticket.id} for Unfuddle ticket #{ticket.unfuddle_id}"

      else
        if unfuddle_ticket.updated_at > ticket.unfuddle_updated_at
          ticket.updates.create({
            :user               => User.first_or_create(:name => unfuddle_ticket.assignee),
            :summary            => unfuddle_ticket.summary,
            :description        => unfuddle_ticket.description,
            :status             => unfuddle_ticket.status,
            :unfuddle_timestamp => unfuddle_ticket.updated_at
          })

          puts "Updated ticket #{ticket.id} based on Unfuddle ticket #{ticket.unfuddle_id}"

        else
          puts "No updates for ticket #{ticket.id}"
        end
      end

      true
    end
  end

  def assignee
    @assignee ||= (self.user ? self.user.name : "")
  end

  def week_updated
    return "" if self.unfuddle_updated_at.nil?
    saturday = self.unfuddle_updated_at + (6 - self.unfuddle_updated_at.wday)
    saturday.strftime("%Y-%m-%d")
  end
end
