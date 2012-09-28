class User
  include DataMapper::Resource

  has n, :comments
  has n, :tickets
  has n, :ticket_updates

  property :id,                Serial
  property :unfuddle_id,       Integer, :unique_index => true
  property :unfuddle_username, String
  property :name,              String,  :index => true
  property :email,             String

  def self.create_from_unfuddle(unfuddle_user)
    self.create({
      :unfuddle_id       => unfuddle_user.id,
      :unfuddle_username => unfuddle_user.username,
      :name              => unfuddle_user.name,
      :email             => unfuddle_user.email
    })
  end
end
