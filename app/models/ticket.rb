class Ticket
  include DataMapper::Resource

  belongs_to :user
  has n, :comments, :order => [ :unfuddle_created_at.desc ]
  has n, :updates, "TicketUpdate", :order => [ :unfuddle_timestamp.desc ]

  property :id,                  Serial
  property :unfuddle_id,         Integer, :unique_index => true
  property :unfuddle_number,     Integer

  # Duplicate properties
  property :user_id,             Integer
  property :summary,             String
  property :description,         Text
  property :status,              String
  property :resolution,          String
  property :estimate,            Decimal
  property :created_at,          DateTime
  property :updated_at,          DateTime
  property :unfuddle_created_at, DateTime
  property :unfuddle_updated_at, DateTime

  def self.create_from_unfuddle(unfuddle_ticket)
    self.create({
      :unfuddle_id         => unfuddle_ticket.id,
      :unfuddle_number     => unfuddle_ticket.number,
      :user                => User.first(:unfuddle_id => unfuddle_ticket.assignee_id),
      :summary             => unfuddle_ticket.summary,
      :description         => unfuddle_ticket.description,
      :status              => unfuddle_ticket.status,
      :unfuddle_created_at => unfuddle_ticket.created_at,
      :unfuddle_updated_at => unfuddle_ticket.updated_at
    })
  end

  def self.closed_or_resolved
    self.all(:status => ["closed", "resolved"])
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
