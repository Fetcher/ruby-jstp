module Writer
  module JSTP
    class Connector
      attr_accessor :source

      def initialize source
        @source = source
      end

      # Dispatch this applying the websocket strategy
      def websocket message
        this_client = ::JSTP::WebSocket.instance
          .client message["resource"]
        json = message.to_json
        this_client.callback do 
          this_client.send_msg json
        end
      end

      # Dispatch thid applying the TCP strategy
      def tcp message
        client = ::JSTP::TCP.instance.client message["resource"].first, @source.port.outbound
        client.puts message.to_json
      end
    end
  end
end