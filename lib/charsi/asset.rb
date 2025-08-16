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
      assets_path = File.join(@config.paths.assets_dir, '**', '*.*')
      
      Dir.glob(assets_path).each do |asset|
        extension        = File.extname(asset)
        destination_dir  = File.join(@config.paths.output_dir, 'assets')
        destination_path = asset.sub(@config.paths.assets_dir, destination_dir)

        next process_and_copy_js(asset, destination_path)  if extension == '.js'
        next process_and_copy_css(asset, destination_path) if extension == '.css'

        Charsi::FileManagement.copy(asset, destination_path)
      end
    end

    private

      def process_and_copy_css(asset, destination_path)
        commands  = [Tailwindcss::Ruby.executable]
        commands += ['input', asset]
        commands += ['output', destination_path]
        commands += ['--minify']
        commands += ['--config', @config.paths.tailwind]
        
        system(*commands)
      end

      def process_and_copy_js(asset, destination_path)
        processed_asset = Terser.compile(File.read(asset))

        Charsi::FileManagement.write(destination_path, processed_asset)
      end
  end
end
