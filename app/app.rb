class UnfuddleMetrics < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  get "/" do
    render :tickets_resolved_by_week
  end
end
