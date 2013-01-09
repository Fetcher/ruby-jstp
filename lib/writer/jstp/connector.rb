module Writer
  module JSTP
    class Connector
      attr_accessor :source

      def initialize source
        @source = source
      end

      # Dispatch this applying the websocket strategy
      def websocket message
        begin 
          this_client = ::JSTP::WebSocket.instance
            .client message["resource"]
          json = message.to_json
          this_client.callback do 
            this_client.send_msg json
            this_client.close_connection_after_writing
          end
        rescue RuntimeError => e
          EM.run {
            this_client = ::JSTP::WebSocket.instance
              .client message["resource"]
            json = message.to_json

            this_client.callback do 
              this_client.send_msg json
              this_client.close_connection_after_writing
            end

            this_client.disconnect do 
              EM::stop_event_loop
            end
          }
        end
      end

      # Dispatch thid applying the TCP strategy
      def tcp message
        client = TCPSocket.open message["resource"].first, @source.port.outbound
        client.puts message.to_json
        client.close
      end
    end
  end
end