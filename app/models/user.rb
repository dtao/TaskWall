class User
  include DataMapper::Resource

  has n, :comments
  has n, :tickets
  has n, :ticket_updates

  property :id,          Serial
  property :unfuddle_id, Integer, :unique_index => true
  property :name,        String,  :index => true
  property :email,       String
end
