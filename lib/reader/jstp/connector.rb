module Reader
  module JSTP
    class Connector
      attr_accessor :source

      def initialize the_source
        @source = the_source
      end

      # Start the server with the websocket strategy
      def websocket
        ::EventMachine.run &::JSTP::WebSocket::EventMachine
      end
    end
  end
end