module Reader
  module JSTP
    class Engine
      def initialize engine
        @config = ::JSTP::Configuration.instance
        @engine = engine
      end

      # Start the server with the websocket strategy
      def websocket
        EM.run do
          EM::WebSocket
            .start host: "0.0.0.0", port: @config.port.inbound do |server|
            
            server.onopen do
              @engine.sockets[UUID.new.generate] = server
            end

            server.onmessage do |message|
              begin
                @message = ::JSTP::Dispatch.new message
                @engine.dispatch(@message, server)
              rescue Exception => exception
                log_exception exception, @message
              end
            end
          end
        end
      end

      # Start the server with the TCP strategy
      def tcp
        @server = TCPServer.open @config.port.inbound
        loop {
          Thread.start(@server.accept) { |client|
            begin 
              @engine.sockets[UUID.new.generate] = client
              @message = ::JSTP::Dispatch.new client.gets
              @engine.dispatch @message, client
              Thread.current.kill
            rescue Exception => exception
              log_exception exception, @message
              Thread.current.kill
            end
          }
        }
      end

      private
        def log_exception exception, message
          @config.logger.error "#{exception.class}: #{exception.message}"
          @config.logger.debug exception.backtrace.to_s
          @config.logger.debug Oj.dump message if message
        end
    end
  end
end