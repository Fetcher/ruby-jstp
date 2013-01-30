module Writer
  module JSTP
    class Connector
      attr_accessor :source

      def initialize source
        @source = source
        @config = JSTP::Configuration.instance
      end

      # Dispatch this applying the websocket strategy
      def websocket message
        host = message["resource"].first
        path = message["resource"][1..-1].join('/')
        connection_uri = "ws://#{host}:#{@config.port.outbound}/#{path}"

        begin 
          ws = EM::WebSocketClient.connect connection_uri
          json = message.to_json
          ws.callback do 
            ws.send_msg json
            ws.close_connection_after_writing
          end
        rescue RuntimeError => e
          EM.run do
            ws = EM::WebSocketClient.connect connection_uri
            json = message.to_json

            ws.callback do 
              ws.send_msg json
              ws.close_connection_after_writing
            end

            ws.disconnect do 
              EM::stop_event_loop
            end
          end
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