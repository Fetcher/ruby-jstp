# -*- encoding : utf-8 -*-
module JSTP

  # Handles the connection functionality for this JSTP reference implementation
  class Connector
    include Singleton
    include Discoverer::Writer
    include Discoverer::Reader

    attr_accessor :port, :strategy, :block

    def initialize
      @port = SymbolMatrix inbound: 33333, outbound: 33333
      @strategy = SymbolMatrix inbound: :tcp, outbound: :tcp
    end
  end
end
