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
                @source.open server, @source.clients.key(server)
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
                @source.close server, @source.clients.key(server)
              end
            end
          end
        end
      end

      # Start the server with the TCP strategy
      def tcp
        @server = TCPServer.new @config.port.inbound          

        @config.logger.info "JSTP node running on TCP mode in port #{@config.port.inbound}"
        loop {
          Thread.start(@server.accept) { |client|
            begin
              # Opening routine
              token = UUID.new.generate 
              @source.clients[token] = client
              if @source.respond_to? :open
                begin
                  @source.open client, token
                rescue Exception => e
                  @config.logger.error "On open hook: #{e.class}: #{e.message}"
                  @config.logger.debug e.backtrace.to_s
                end
              end

              # Message loop
              while line = client.gets
                begin
                  @message = ::JSTP::Dispatch.new line
                  @source.dispatch @message, client
                rescue Exception => e
                  log_exception e, @message
                end
              end

              # Closing routine
              client.close
              @source.clients.delete token
              if @source.respond_to? :close
                @source.close client, token
              end
            rescue Exception => exception
              @config.logger.error "Client #{token} is DOWN: #{exception.class}: #{exception.message}"
              @config.logger.debug exception.backtrace.to_s
              client.close
            end
          }
        }
      rescue Exception => e
        @config.logger.fatal "Could not initialize TCP server on port #{@config.port.inbound}"
      end

      private
        def log_exception exception, message
          @config.logger.error "#{exception.class}: #{exception.message}"
          @config.logger.debug exception.backtrace.to_s
          @config.logger.debug ::JSTP::Dispatch.new(message).to.string if message
        end
    end
  end
end