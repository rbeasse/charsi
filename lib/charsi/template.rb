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
        output_file = File.basename(view, '.erb') + '.html'
        output_path = @config.path(:output_dir, output_file)

        processed_view = parse_erb_with_layout(view)

        Charsi::FileManagement.write(output_path, processed_view)
      end
    end

    private

    def parse_erb_with_layout(view_path, layout: 'default.erb')
      layout_path = @config.path(:layout_dir, layout)

      layout = Tilt::ERBTemplate.new(layout_path)
      view   = Tilt::ERBTemplate.new(view_path)

      layout.render(@app) { view.render(@app) }
    end
  end
end
