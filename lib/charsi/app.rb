module Charsi
  # Standard app class.
  #
  # This class is used to build the app. It includes all utility methods to be acccessed through the
  # templating.
  class App
    attr_reader :cache_slug, :assets

    def initialize
      @cache_slug = Time.now.to_i
      @assets     = {}
    end

    protected

      def stylesheet_tag(asset)
        "<link rel='stylesheet' href='assets/css/#{asset}?#{@cache_slug}'>"
      end

      # Helper method to include a javascript tag.
      def javascript_tag(asset)
        "<script src='assets/javascript/#{asset}?#{@cache_slug}'></script>"
      end
  end
end