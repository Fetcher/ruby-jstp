module Reader
  module JSTP
    class Connector
      attr_accessor :source

      def initialize the_source
        @source = the_source
      end

      # Start the server with the websocket strategy
      def websocket
        EM.run do
          EM::WebSocket
            .start host: "0.0.0.0", port: Connector.instance.port.inbound do 
              |server|
            
            server.onopen do
              JSTP::WebSocket.instance.sockets[UUID.new.generate] = server
            end

            server.onmessage do |message|
              message = JSON.parse message
              JSTP::Engine.instance.dispatch(message, 
                JSTP::WebSocket.instance.sockets.key(server))
            end
        end
      end

      # Start the server with the TCP strategy
      def tcp
        @server = TCPServer.open @source.port.inbound
        loop {
          Thread.start(@server.accept) { |client|
            begin 
              ::JSTP::Engine.instance.dispatch JSON.parse client.gets
            rescue Exception => e
              puts "\e[31m#{e.message}\e[0m"
              puts e.backtrace
            end
          }
        }
      end
    end
  end
end