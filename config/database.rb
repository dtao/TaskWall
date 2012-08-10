DataMapper.logger = logger
DataMapper::Property::String.length(255)

case Padrino.env
  when :production  then DataMapper.setup(:default, ENV["HEROKU_POSTGRESQL_GOLD_URL"])
  when :development then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "unfuddle_metrics_development.db"))
  when :test        then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "unfuddle_metrics_test.db"))
end
