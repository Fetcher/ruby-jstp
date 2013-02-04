module Reader
  module JSTP
    class Engine
      def initialize source
        @config = ::JSTP::Configuration.instance
        @source = source
      end

      # Start the server with the websocket strategy
      def websocket
        EM.run do
          EM::WebSocket
            .start host: "0.0.0.0", port: @config.port.inbound do |server|
            
            server.onopen do
              @source.clients[UUID.new.generate] = server
              if @source.respond_to? :open
                @source.open server, @source.clients.key server
              end
            end

            server.onmessage do |message|
              begin
                @message = ::JSTP::Dispatch.new message
                @source.dispatch(@message, server)
              rescue Exception => exception
                log_exception exception, @message
              end
            end

            server.onclose do 
              if @source.respond_to? :close
                @source.close server, @source.clients.key server
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
              @source.clients[UUID.new.generate] = client
              @message = ::JSTP::Dispatch.new client.gets
              @source.dispatch @message, client
              client.close
            rescue Exception => exception
              log_exception exception, @message
              client.close
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