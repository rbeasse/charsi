module Charsi
  # Builds the application and handles file watching for changes.
  class Builder
    def initialize
      @app    = defined?(::App) ? ::App.new : Charsi::App.new
      @config = Configuration.new
    end

    def build
      start_time = Time.now

      Charsi::FileManagement.reset_output_dir(@config.path(:output_dir))
      Charsi::Asset.new(@config).build
      Charsi::Template.new(@app, @config).build

      puts "[charsi] Build completed in #{Time.now - start_time} seconds."
    end

    def watch
      Filewatcher.new(watch_paths).watch do |changes|
        changes.each do |filename, event|
          puts "[charsi][#{event}] #{filename}"
        end
        
        build
      end
    rescue Interrupt
      puts "\n[charsi] Done watching."
    end

    private

    def watch_paths
      [
        @config.path(:assets_dir), 
        @config.path(:views_dir), 
        @config.path(:layout_dir)
      ]
    end
  end
end
