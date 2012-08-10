class Ticket
  include DataMapper::Resource

  belongs_to :user

  property :id,                  Serial
  property :user_id,             Integer
  property :unfuddle_id,         Integer
  property :summary,             String
  property :description,         Text
  property :status,              String
  property :estimate,            Decimal
  property :created_at,          DateTime
  property :updated_at,          DateTime
  property :unfuddle_created_at, DateTime
  property :unfuddle_updated_at, DateTime

  def self.fetch_latest
    latest_id = self.max(:unfuddle_id) || 0

    client = Unfuddle::Client.load_from_yaml(File.join(PADRINO_ROOT, "config", "unfuddle.yml"))
    project = client.project(1)

    project.each_ticket do |t|
      if t.id <= latest_id
        false

      else
        ticket = self.first(:unfuddle_id => t.id)

        if ticket.nil?
          ticket = self.create({
            :user_id => User.first_or_create(:name => t.assignee).id,
            :unfuddle_id => t.id,
            :summary => t.summary,
            :description => t.description,
            :status => t.status,
            :unfuddle_created_at => t.created_at,
            :unfuddle_updated_at => t.updated_at
          })

          puts "Ticket added to DB: #{ticket.unfuddle_updated_at}"
        end

        true
      end
    end
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
