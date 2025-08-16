module Charsi
  # Itterates each assets, processes them, and copies them to the output directory.
  #
  # JavaScript and CSS files are minified.
  class Asset
    def initialize(app, config)
      @app    = app
      @config = config
    end

    def build
      Dir.glob(@config.assets_path).each do |asset|
        extension        = File.extname(asset)
        destination_path = asset.sub(@config.assets_dir, File.join(@config.output_dir, 'assets'))

        next process_and_copy_js(asset, destination_path)  if extension == '.js'
        next process_and_copy_css(asset, destination_path) if extension == '.css'

        Charsi::FileManagement.copy(asset, destination_path)
      end
    end

    private

      def process_and_copy_css(asset, destination_path)
        config_path = File.join(Dir.pwd, 'tailwind.config.js')
        commands = [Tailwindcss::Ruby.executable, '--input', asset, '--output', destination_path, '--minify']
        
        if File.exist?(config_path)
          commands += ['--config', config_path]
        end
        
        system(*commands)
      end

      def process_and_copy_js(asset, destination_path)
        processed_asset = Terser.compile(File.read(asset))

        Charsi::FileManagement.write(destination_path, processed_asset)
      end
  end
end
