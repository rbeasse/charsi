module Charsi
  # Handles the configuration of Charsi. Reads from both the config.yml in the gem and the config.yml in the app. Prioritizes the
  # app config.
  #
  # The config.yml file in the app is optional. If it does not exist, Charsi will use the default config.yml file in the gem.
  class Configuration
    def initialize
      @config ||= default_config.merge(app_config)
    end

    def output_dir
      File.join(Dir.pwd, @config['build']['output_dir'])
    end

    def views_dir
      File.join(Dir.pwd, @config['build']['views_dir'])
    end

    def layout_dir
      File.join(Dir.pwd, @config['build']['layout_dir'])
    end

    def assets_dir
      File.join(Dir.pwd, @config['build']['assets_dir'])
    end

    def views_path
      File.join(views_dir, '*.erb')
    end

    def assets_path
      File.join(assets_dir, '**', '*.*')
    end

    def layout_path(layout_name = 'default.erb')
      File.join(layout_dir, layout_name)
    end

    private

      def default_config
        YAML.load_file(File.join(__dir__, '../../config.yml'))
      end

      def app_config
        app_config_path = File.expand_path('config.yml', Dir.pwd)

        File.exist?(app_config_path) ? YAML.load_file(app_config_path) : {}
      end
  end
end