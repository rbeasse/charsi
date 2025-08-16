module Charsi
  # Itterates each assets, processes them, and copies them to the output directory.
  #
  # JavaScript and CSS files are minified.
  class Asset
    def initialize(config)
      @config = config
    end

    def build
      assets_path = @config.path(:assets_dir, '**', '*.*')
      
      Dir.glob(assets_path).each do |asset|
        extension        = File.extname(asset)
        destination_dir  = @config.path(:output_dir, 'assets')
        destination_path = asset.sub(@config.path(:assets_dir), destination_dir)

        next process_javascript(asset, destination_path)  if extension == '.js'
        next process_tailwind(asset, destination_path) if asset.include?('tailwind.css')

        Charsi::FileManagement.copy(asset, destination_path)
      end
    end

    private

    def process_tailwind(asset, destination_path)
      commands  = [Tailwindcss::Ruby.executable]
      commands += ['-i', asset, '-o', destination_path, '--minify']
      commands += ['--config', 'tailwind.config.js']

      system(*commands)
    end

    def process_javascript(asset, destination_path)
      processed_asset = Terser.compile(File.read(asset))

      Charsi::FileManagement.write(destination_path, processed_asset)
    end
  end
end
