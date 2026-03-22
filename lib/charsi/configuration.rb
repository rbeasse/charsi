module Charsi
  # Handles configuration for the Charsi application.
  class Configuration
    CONFIG_FILE = 'config.yml'.freeze

    def initialize
      @config ||= app_config
    end

    def path(config_key, *keys)
      config_path = @config.dig('paths', config_key.to_s)

      File.join(Dir.pwd, config_path, *keys)
    end


    private

    def app_config
      app_config_path = File.join(Dir.pwd, CONFIG_FILE)

      YAML.safe_load_file(app_config_path)
    end
  end
end
