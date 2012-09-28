class TicketUpdate
  include DataMapper::Resource

  belongs_to :user
  belongs_to :ticket

  property :id,                 Serial
  property :ticket_id,          Integer

  # Duplicate properties
  property :user_id,            Integer
  property :summary,            String
  property :description,        Text
  property :status,             String
  property :resolution,         String
  property :estimate,           Decimal
  property :created_at,         DateTime
  property :unfuddle_timestamp, DateTime

  before :create do
    self.user               ||= self.ticket.user
    self.summary            ||= self.ticket.summary
    self.description        ||= self.ticket.description
    self.status             ||= self.ticket.status
    self.resolution         ||= self.ticket.resolution
    self.estimate           ||= self.ticket.estimate
    self.unfuddle_timestamp ||= self.ticket.unfuddle_updated_at
  end

  after :create do
    self.ticket.update({
      :user                => self.user,
      :summary             => self.summary,
      :description         => self.description,
      :status              => self.status,
      :resolution          => self.resolution,
      :estimate            => self.estimate,
      :unfuddle_updated_at => self.unfuddle_timestamp
    })
  end
end
