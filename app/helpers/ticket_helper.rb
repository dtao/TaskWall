module TicketHelper
  def classes_for_ticket_card(ticket)
    classes = ["status-#{ticket.status}"]
    classes << "resolution-#{ticket.resolution}" unless ticket.resolution.blank?
    classes.join(" ")
  end
end

UnfuddleMetrics.helpers do
  include TicketHelper
end
