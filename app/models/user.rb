class User
  include DataMapper::Resource

  has n, :tickets

  property :id,          Serial
  property :name,        String, :index => true
end
