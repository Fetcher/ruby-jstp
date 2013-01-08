# -*- encoding : utf-8 -*-
module JSTP
  module API
    def dispatch *args, &block
      if args.empty? and block
        Connector.instance.block = block
        Connector.instance.from.send Connector.instance.strategy.inbound
      else
        Connector.instance.to.send Connector.instance.strategy.outbound, args.first
      end
    end

    def port data
      Connector.instance.port = SymbolMatrix data
    end

    def strategy data
      Connector.instance.strategy = SymbolMatrix data
    end
  end
end
