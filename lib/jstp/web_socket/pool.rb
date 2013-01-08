module JSTP
  module WebSocket
    class Pool
      include Singleton

      # Access to the client pool
      # @param [Array] the resource data
      # @return [EventMachine::WebSocketClient] the client for the address
      def client resource
        ::EventMachine::WebSocketClient.connect "ws://#{resource.first}:33333/#{resource[1..-1].join('/')}"
      end
    end
  end
end