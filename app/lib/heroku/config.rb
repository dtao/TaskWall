module Heroku
  class Config
    def self.vars_from_yaml(environment="development")
      config_vars = []

      ["google.yml", "unfuddle.yml"].each do |file|
        config = YAML.load_file(File.join(PADRINO_ROOT, "config", file))[environment]
        config.each do |name, value|
          config_vars << [name, value]
        end
      end

      config_vars
    end
  end
end
