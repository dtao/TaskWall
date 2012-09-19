module TicketHelper
  def classes_for_ticket_card(ticket)
    classes = [ticket.status]
    classes << "has-updates" if ticket.updates.any?
    classes << "has-comment" if ticket.comments.any?
    classes.join(" ")
  end
end

UnfuddleMetrics.helpers do
  include TicketHelper
end
