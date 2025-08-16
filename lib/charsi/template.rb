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
      Dir.glob(@config.views_path).each do |view|
        output_file = File.basename(view, '.erb') + '.html'
        output_path = File.join(@config.output_dir, output_file)

        processed_view = parse_erb_with_layout(view)

        Charsi::FileManagement.write(output_path, processed_view)
      end
    end


    private

      # Parses an ERB file with a layout (also an ERB file).
      def parse_erb_with_layout(view_path, layout: 'default.erb')
        layout_path = @config.layout_path(layout)

        layout = Tilt::ERBTemplate.new(layout_path)
        view   = Tilt::ERBTemplate.new(view_path)

        layout.render(@app) { view.render(@app) }
      end
  end
end