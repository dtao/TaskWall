module Heroku
  class Config
    def self.vars_from_yaml
      config = YAML.load_file(File.join(PADRINO_ROOT, "config", "heroku.yml"))

      config_vars = config.map do |name, subvars|
        subvars.map do |key, value|
          ["#{name}_#{key}".upcase, value]
        end
      end

      config_vars.flatten(1)
    end
  end
end
