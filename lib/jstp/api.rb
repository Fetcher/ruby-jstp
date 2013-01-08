# -*- encoding : utf-8 -*-
module JSTP
  module API
    def dispatch *args, &block
      if args.empty? and block
        Registry.instance.set block

        Connector.instance.start 
      else
        Connector.instance.dispatch args.first
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
