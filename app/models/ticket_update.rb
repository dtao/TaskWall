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
