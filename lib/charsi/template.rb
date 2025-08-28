module Charsi
  # Itterates over all views and builds them into the output directory.
  #
  # Each view is created with a layout. The default layout is `default.erb`.
  class Template
    def initialize(app, config)
      @app    = app
      @config = config
    end

    def build
      views_path = @config.path(:views_dir, '*.erb')
      
      Dir.glob(views_path).each do |view|
        next if File.basename(view).start_with?('_')

        output_file = determine_output_filename(view)
        output_path = @config.path(:output_dir, output_file)

        processed_view = parse_erb_with_layout(view)

        Charsi::FileManagement.write(output_path, processed_view)
      end
    end

    private

    def determine_output_filename(view_path)
      basename = File.basename(view_path, '.erb')
      
      # If basename already has an extension, use it as-is
      # otherwise, default to .htmli
      basename.include?('.') ? basename : "#{basename}.html"
    end

    def parse_erb_with_layout(view_path, layout: 'default.erb')
      layout_path = @config.path(:layout_dir, layout)

      layout = Tilt::ERBTemplate.new(layout_path)
      view   = Tilt::ERBTemplate.new(view_path)

      layout.render(@app) { view.render(@app) }
    end
  end
end
