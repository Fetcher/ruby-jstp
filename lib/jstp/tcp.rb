module JSTP
  class TCP
    include Singleton
    def initialize 
      @client_pool = {}
    end

    def client hostname, port
      @client_pool["#{hostname}:#{port}"] ||= TCPSocket.open hostname, port
    end
  end
end