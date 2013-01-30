module JSTP
  class WebSocket
    include Singleton

    def sockets
      @sockets ||= {}
    end
  end
end