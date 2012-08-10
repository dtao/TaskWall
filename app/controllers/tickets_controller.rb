UnfuddleMetrics.controllers :tickets do
  get :closed_by_week, :provides => :json do
    tickets = Ticket.all(:status => "closed", :unfuddle_updated_at.gte => (DateTime.now - 90))

    grouped_by_week = tickets.group_by(&:week_updated).to_a
    grouped_by_week.sort_by!(&:first)

    dates = grouped_by_week.map(&:first)
    tickets_per_week = grouped_by_week.map { |week, tickets| tickets }
    names = tickets_per_week.flatten.map(&:assignee).uniq

    {
      :dates => dates,
      :series => names.map { |name|
        {
          :name => name,
          :data => tickets_per_week.map { |tickets|
            tickets.select { |t| t.assignee == name }.count
          }
        }
      }
    }.to_json
  end
end
