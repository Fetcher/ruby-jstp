module Reader
  module JSTP
    class Connector
      attr_accessor :source

      def initialize the_source
        @source = the_source
      end

      # Start the server with the websocket strategy
      def websocket
        ::EventMachine.run &::JSTP::WebSocket.instance.event_machine
      end

      # Start the server with the TCP strategy
      def tcp
        @server = TCPServer.open @source.port.inbound
        loop {
          Thread.start(@server.accept) { |client|
            ::JSTP::Engine.instance.dispatch JSON.parse client.gets
          }
        }
      end
    end
  end
end