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
      assets_path = File.join(APP_DIR, ASSETS_DIR, '**', '*.*')

      Dir.glob(assets_path).each do |asset|
        extension        = File.extname(asset)
        destination_path = asset.sub(APP_DIR, OUTPUT_DIR)

        next process_and_copy_js(asset, destination_path)  if extension == '.js'
        next process_and_copy_css(asset, destination_path) if %w[.css .scss].include? extension

        Charsi::FileManagement.copy(asset, destination_path)
      end
    end

    private

      def process_and_copy_css(asset, destination_path)
        processed_asset = SassC::Engine.new(File.read(asset), style: :compressed).render

        Charsi::FileManagement.write(destination_path, processed_asset)
      end

      def process_and_copy_js(asset, destination_path)
        processed_asset = Terser.compile(File.read(asset))

        Charsi::FileManagement.write(destination_path, processed_asset)
      end
  end
end