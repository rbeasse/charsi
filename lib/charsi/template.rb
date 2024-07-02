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
      views_path = File.join(APP_DIR, VIEWS_DIR, '*.erb')

      Dir.glob(views_path).each do |view|
        output_file = File.basename(view, '.erb') + '.html'
        output_path = File.join(OUTPUT_DIR, output_file)

        processed_view = parse_erb_with_layout(view)

        Charsi::FileManagement.write(output_path, processed_view)
      end
    end


    private

      # Parses an ERB file with a layout (also an ERB file).
      def parse_erb_with_layout(view_path, app, layout: 'default.erb')
        layout_path = File.join(APP_DIR, LAYOUT_DIR, layout)

        layout = Tilt::ERBTemplate.new(layout_path)
        view   = Tilt::ERBTemplate.new(view_path)

        layout.render(@app) { view.render(@app) }
      end
  end
end