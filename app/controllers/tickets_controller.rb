UnfuddleMetrics.controllers :tickets do
  get :by_week, :provides => :html do
    grouped_by_week = Ticket.all(:created_at.gt => (Time.now - 6.months)).group_by(&:week_updated)

    @tickets     = []
    @statuses    = Set.new
    @resolutions = Set.new
    grouped_by_week.each do |week, tickets_for_week|
      @tickets << [week, tickets_for_week.group_by(&:user_id)]
      tickets_for_week.each do |ticket|
        @statuses.add(ticket.status)
        @resolutions.add(ticket.resolution) unless ticket.resolution.blank?
      end
    end

    @selected_statuses = ["closed", "resolved"]

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
    @ticket = Ticket.first(:unfuddle_id => params[:ticket_id].strip)
    Comment.post(unfuddle_client, @ticket, params[:comment])
    render :"tickets/ticket", :layout => false
  end
end
