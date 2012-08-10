source :rubygems

# Server requirements
gem "thin"

# Project requirements
gem "rake"
gem "sinatra-flash", :require => "sinatra/flash"

# Component requirements
gem "json"
gem "httparty"
gem "sass"
gem "haml"
gem "dm-validations"
gem "dm-timestamps"
gem "dm-migrations"
gem "dm-constraints"
gem "dm-aggregates"
gem "dm-core"

group :production do
  gem "dm-postgres-adapter"
  gem "pg"
end

# Dev requirements
group :development do
  gem "dm-sqlite-adapter"
  gem "heroku"
end

# Padrino Stable Gem
gem "padrino", "0.10.6"
