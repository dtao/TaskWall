class User
  include DataMapper::Resource

  has n, :ticket_updates

  property :id,          Serial
  property :name,        String, :index => true
end
