# -*- encoding : utf-8 -*-
module JSTP
  module API
    def dispatch *args, &block
      if args.empty? and block
        Connector.instance.block = block
        Connector.instance.from.websocket 
      else
        Connector.instance.to.websocket args.first
      end
    end

    def port number
      Connector.instance.port = number
    end

    def strategy symbol
      Connector.instance.strategy = symbol
    end
  end
end
