# -*- encoding : utf-8 -*-
module JSTP

  # Handles the connection functionality for this JSTP reference implementation
  class Connector
    include Singleton
    include Discoverer::Writer

    attr_accessor :port, :strategy

    def initialize
      @port = 33333
      @strategy = :tcp
    end

    # Discovers the server and sends the message
    # @param [Hash/Array] message
    def dispatch message
      to.send @strategy, message
    end

    # Sets up the server to be executed within an EventMachine reactor
    def server
      ::EventMachine::WebSocket.start host: "0.0.0.0", port: @port, &JSTP::Server
    end

    # Starts the server with the block from the Registry
    def start
      ::EventMachine.run &JSTP::EventMachine
    end
  end
end
