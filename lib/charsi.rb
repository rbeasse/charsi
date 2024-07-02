require 'erb'
require 'fileutils'
require 'tilt'
require 'terser'
require 'sassc'
require 'yaml'

module Charsi
  require 'charsi/configuration'
  require 'charsi/file'
  require 'charsi/template'
  require 'charsi/asset'
  require 'charsi/app'

  # Allow the user to define their own App class. Check if the file exists, and if it does, require it so Charsi
  # can use it.
  if File.exist?('app/app.rb')
    require './app/app'
  end

  class << self
    # Builds and compiles our assets and templates.
    #
    # This is the main method that is called when running `charsi build`.
    def build
      app    = defined?(::App) ? ::App.new : Charsi::App.new
      config = Configuration.new

      # Clean up the output directory before building.
      Charsi::FileManagement.reset_output_dir

      Charsi::Asset.new(app, config).build
      Charsi::Template.new(app, config).build
    end
  end
end
