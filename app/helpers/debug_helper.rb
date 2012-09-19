module DebugHelper
  def println(message)
    puts message
    STDIN.readline
  end
end

UnfuddleMetrics.helpers do
  include DebugHelper
end
