class Ticket
  include DataMapper::Resource

  belongs_to :user
  has n, :comments
  has n, :updates, "TicketUpdate"

  property :id,                  Serial
  property :unfuddle_id,         Integer, :unique_index => true

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

  def assignee
    @assignee ||= (self.user ? self.user.name : "")
  end

  def week_updated
    return "" if self.unfuddle_updated_at.nil?
    saturday = self.unfuddle_updated_at + (6 - self.unfuddle_updated_at.wday)
    saturday.strftime("%Y-%m-%d")
  end
end
