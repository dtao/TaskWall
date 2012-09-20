class UnfuddleMetrics < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  disable :reload

  configure :production do
    use Rack::SslEnforcer
  end

  before do
    unless request.ip == "38.104.129.82" || Padrino.env == :development
      raise "You are not allowed to access this website."
    end
  end

  helpers do
    def unfuddle_client
      @unfuddle_client ||= Unfuddle::Client.new
    end
  end

  get "/" do
    render :index
  end

  error do
    "Sorry - #{env['sinatra.error'].message}"
  end
end
