# -*- encoding : utf-8 -*-
module JSTP

  # Handles the connection functionality for this JSTP reference implementation
  class Connector
    include Singleton
    include Discoverer::Writer
    include Discoverer::Reader

    attr_accessor :port, :strategy, :block

    def initialize
      @port = 33333
      @strategy = :tcp
    end

    # Sets up the server to be executed within an EventMachine reactor
    def server
      ::EventMachine::WebSocket.start host: "0.0.0.0", port: @port, &JSTP::WebSocket::Server
    end
  end
end
