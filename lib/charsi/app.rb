module Charsi
  # Standard app class.
  #
  # This class is used to build the app. It includes all utility methods to be acccessed through the
  # templating.
  class App
    attr_reader :cache_slug

    def initialize
      @cache_slug = Time.now.to_i
      @config = Configuration.new

      load_helpers
    end

    protected

    def stylesheet_tag(asset)
      "<link rel='stylesheet' href='assets/css/#{asset}?#{@cache_slug}'>"
    end

    def javascript_tag(asset)
      "<script src='assets/javascript/#{asset}?#{@cache_slug}'></script>"
    end

    def render_partial(partial_name, **locals)
      partial_path = @config.path(:views_dir, "_#{partial_name}.erb")
      template     = Tilt::ERBTemplate.new(partial_path)
      
      template.render(self, **locals)
    end

    private

    def load_helpers
      helpers_path = @config.path(:helpers_dir)

      Dir.glob(File.join(helpers_path, '**', '*.rb')).each do |helper_file|
        require_relative helper_file
      end
    end
  end
end
