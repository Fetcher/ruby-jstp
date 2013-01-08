module JSTP
  class WebSocket
    include Singleton

    def sockets
      @sockets ||= {}
    end

    def server_setup
      @server_setup ||= proc { |server|
        server.onopen {
          JSTP::WebSocket.instance.sockets[UUID.new.generate] = server
        }

        server.onmessage { |message|
          message = JSON.parse message
          Connector.instance.block.call message, 
            JSTP::WebSocket.instance.sockets.key(server)
        }
      }
    end

    def event_machine
      @event_machine ||= proc {
        ::EM::WebSocket.start host: "0.0.0.0", 
                              port: Connector.instance.port.inbound, 
                              &WebSocket.instance.server_setup
      }
    end

    def event_on_message
      @event_on_message ||= proc { |message|
        
      }
    end

    def event_on_open
    end

    def client resource
      ::EM::WebSocketClient
        .connect "ws://#{resource.first}:#{Connector.instance.port.outbound}/#{resource[1..-1].join('/')}"
    end
  end
end