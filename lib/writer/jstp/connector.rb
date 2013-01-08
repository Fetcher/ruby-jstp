module Writer
  module JSTP
    class Connector
      attr_accessor :source

      def initialize source
        @source = source
      end

      # Dispatch this applying the websocket strategy
      def websocket message
        this_client = ::JSTP::WebSocket::Pool.instance
          .client message["resource"]
        json = message.to_json
        this_client.callback do 
          this_client.send_msg json
        end
      end
    end
  end
end