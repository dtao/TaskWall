source :rubygems

# Server requirements
gem "rack-rewrite"
gem "thin"

# Project requirements
gem "rake"
gem "sinatra-flash", :require => "sinatra/flash"

# Component requirements
gem "data_mapper", "~> 1.1.0"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "rack-ssl-enforcer"
gem "builder"
gem "json"
gem "httparty"
gem "sass"
gem "haml"
gem "RedCloth"

group :production do
  gem "dm-postgres-adapter"
  gem "pg"
end

# Dev requirements
group :development do
  gem "dm-sqlite-adapter"
  gem "heroku"
  gem "shotgun"
end

# Padrino Stable Gem
gem "padrino", "0.10.6"
