require 'webrick'

module Charsi
  class Server
    DEFAULT_PORT = 8000

    def initialize
      @config = Configuration.new
    end

    def serve
      build_dir = @config.path(:output_dir)
      
      server = WEBrick::HTTPServer.new(Port: DEFAULT_PORT, DocumentRoot: build_dir)
      trap('INT') { server.shutdown }
      
      puts "[charsi] Serving #{build_dir} at http://localhost:#{DEFAULT_PORT}"
      
      server.start
    end
  end
end