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

  def self.create_from_unfuddle(unfuddle_comment)
    self.create({
      :user                => User.first(:unfuddle_id => unfuddle_comment.user_id),
      :unfuddle_id         => unfuddle_comment.id,
      :ticket              => Ticket.first(:unfuddle_id => unfuddle_comment.ticket_id),
      :body                => unfuddle_comment.body,
      :unfuddle_created_at => unfuddle_comment.created_at,
      :unfuddle_updated_at => unfuddle_comment.updated_at
    })
  end

  def self.post(client, ticket, body)
    request_body = {
      :parent_type => "Ticket",
      :parent_id   => ticket.unfuddle_id,
      :body        => body
    }.to_xml(:root => "comment")

    client.post("projects/1/tickets/#{ticket.unfuddle_id}/comments", request_body) do |response|
      unfuddle_id = response.headers["Location"].split("/").last

      unfuddle_comment = self.create({
        :user                => User.first(:name.like => "%Dan%"),
        :unfuddle_id         => unfuddle_id,
        :ticket              => ticket,
        :body                => body,
        :unfuddle_created_at => Time.now,
        :unfuddle_updated_at => Time.now
      })
    end
  end
end
