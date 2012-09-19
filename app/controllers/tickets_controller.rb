UnfuddleMetrics.controllers :tickets do
  get :closed_by_week, :provides => :html do
    grouped_by_week = Ticket.closed_or_resolved.group_by(&:week_updated)

    @tickets = []
    grouped_by_week.each do |week, tickets_for_week|
      @tickets << [week, tickets_for_week.group_by(&:assignee)]
    end

    @users = ["robby", "george", "teddy", "dan", "boris"].map do |name|
      User.first(:name.like => "%#{name}%")
    end

    render :"tickets/closed_by_week"
  end
end
