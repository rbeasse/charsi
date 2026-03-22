module Charsi
  # Itterates each assets, processes them, and copies them to the output directory.
  class Asset
    UNPKG_BASE = 'https://unpkg.com/'.freeze

    def initialize(config)
      @config = config
    end

    def build
      build_vendor

      assets_path = @config.path(:assets_dir, '**', '*.*')

      Dir.glob(assets_path).each do |asset|
        destination_dir  = @config.path(:output_dir, 'assets')
        destination_path = asset.sub(@config.path(:assets_dir), destination_dir)

        next process_tailwind(asset, destination_path) if asset.include?('tailwind.css')

        Charsi::FileManagement.copy(asset, destination_path)
      end
    end

    private

    def build_vendor
      @config.vendor.each do |key, package_path|
        cache_path  = @config.path(:cache_dir, 'vendor', "#{key}.js")
        output_path = @config.path(:output_dir, 'assets', 'vendor', "#{key}.js")

        Charsi::FileManagement.cached(cache_path) do |path|
          puts "[charsi] Downloading vendor: #{key}"
          Charsi::FileManagement.download("#{UNPKG_BASE}#{package_path}", path)
        end

        Charsi::FileManagement.copy(cache_path, output_path)
      end
    end

    def process_tailwind(asset, destination_path)
      commands  = [Tailwindcss::Ruby.executable]
      commands += ['-i', asset, '-o', destination_path, '--minify']
      commands += ['--config', 'tailwind.config.js']

      system(*commands)
    end
  end
end
