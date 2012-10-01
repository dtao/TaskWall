UnfuddleMetrics.controllers :tickets do
  get :mine, :provides => :html do
    @tickets     = current_user.tickets(:created_at.gt => (Time.now - 6.months)).group_by(&:week_updated)
    @statuses    = @tickets.values.flatten.map(&:status).uniq
    @resolutions = @tickets.values.flatten.map(&:resolution).reject(&:blank?).uniq
    render :"tickets/mine"
  end

  get :by_week, :provides => :html do
    grouped_by_week = Ticket.all(:created_at.gt => (Time.now - 6.months)).group_by(&:week_updated)

    @tickets     = []
    @statuses    = grouped_by_week.values.flatten.map(&:status).uniq
    @resolutions = grouped_by_week.values.flatten.map(&:resolution).reject(&:blank?).uniq
    grouped_by_week.each do |week, tickets_for_week|
      @tickets << [week, tickets_for_week.group_by(&:user_id)]
    end

    @users = ["Robby", "George", "Teddy", "Dan", "Boris"].map do |name|
      User.first(:name.like => "%#{name}%")
    end

    render :"tickets/by_week"
  end

  get :index, :with => :id, :provides => :html do
    @ticket = Ticket.first(:unfuddle_id => params[:id].strip)
    render :"tickets/ticket", :layout => false
  end

  post :comment, :with => :ticket_id, :provides => :html do
    halt redirect("/unfuddle_login") if !authenticated?
    @ticket = Ticket.first(:unfuddle_id => params[:ticket_id].strip)
    Comment.post(unfuddle_client, @ticket, params[:comment])
    render :"tickets/ticket", :layout => false
  end
end
