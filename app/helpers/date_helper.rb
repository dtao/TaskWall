module DateHelper
  def format_date(date)
    date.strftime("%l:%M on %b %d")
  end
end

UnfuddleMetrics.helpers do
  include DateHelper
end
