class UnfuddleMetrics < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  disable :reload

  configure :production do
    use Rack::SslEnforcer

    use OmniAuth::Builder do
      provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {access_type: "online", approval_prompt: ""}
    end
  end

  before do
    if !logged_in?
      redirect "/" unless request.path == "/"
    end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.get(session[:user_id])
    end

    def unfuddle_client
      @unfuddle_client ||= Unfuddle::Client.new
    end
  end

  get "/" do
    render :index
  end

  get "/auth/google_oauth2/callback" do
    auth_hash = request.env["omniauth.auth"]

    user = User.first(:email => user_info["email"])

    if user
      session[:user_id] = user.id
    else
      flash[:notice] = "You cannot log in unless you are part of the Unfuddle project!"
    end

    redirect "/"
  end

  error do
    "Sorry - #{env['sinatra.error'].message}"
  end
end
