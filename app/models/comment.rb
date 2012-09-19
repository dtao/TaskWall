class Comment
  include DataMapper::Resource

  belongs_to :user
  belongs_to :ticket

  property :id,                  Serial
  property :unfuddle_id,         Integer, :unique_index => true
  property :user_id,             Integer
  property :ticket_id,           Integer
  property :body,                Text
  property :created_at,          DateTime
  property :unfuddle_created_at, DateTime
  property :unfuddle_updated_at, DateTime
end
