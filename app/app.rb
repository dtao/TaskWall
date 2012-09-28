class UnfuddleMetrics < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  disable :reload

  configure do
    use Rack::SslEnforcer

    #Enable sinatra sessions
    session_secret = "ycogs5752850291n8svf58l141ox123232d7280l89624d80y727ax9zm13x"
    set :session_secret, session_secret

    use Rack::Session::Cookie, {
      :key          => "_rack_session",
      :path         => "/",
      :expire_after => 2592000, # In seconds
      :secret       => session_secret
    }

    use OmniAuth::Builder do
      provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {access_type: "online", approval_prompt: ""}
    end
  end

  before do
    if !logged_in?
      redirect "/" unless ["/", "/auth/google_oauth2", "/auth/google_oauth2/callback"].include?(request.path)
    end
    if !authenticated?
      redirect "/unfuddle_login" unless ["/unfuddle_login", "/auth/google_oauth2/callback"].include?(request.path)
    end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def authenticated?
      !!unfuddle_creds[:password]
    end

    def current_user
      @current_user ||= User.get(session[:user_id])
    end

    def unfuddle_creds
      {
        :username => current_user.unfuddle_username,
        :password => session[:unfuddle_password]
      }
    end

    def unfuddle_client
      @unfuddle_client ||= Unfuddle::Client.new(unfuddle_creds)
    end
  end

  get "/" do
    render :index
  end

  get "/unfuddle_login" do
    render :unfuddle_login
  end

  post "/unfuddle_login" do
    session[:unfuddle_password] = params[:password]
    redirect "/"
  end

  get "/logout" do
    session.delete(:user_id)
    session.delete(:unfuddle_password)
    redirect "/"
  end

  get "/auth/google_oauth2/callback" do
    auth_hash = request.env["omniauth.auth"]
    user_info = auth_hash["info"]

    user = User.first(:email => user_info["email"])

    if user
      session[:user_id] = user.id
    else
      flash[:notice] = "You cannot log in unless you are part of the Unfuddle project!"
    end

    if !authenticated?
      redirect "/auth_unfuddle"
    end

    redirect "/"
  end

  error do
    "Sorry - #{env['sinatra.error'].message}"
  end
end
