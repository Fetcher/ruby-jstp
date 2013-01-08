# -*- encoding : utf-8 -*-
module JSTP
  module API
    def dispatch *args, &block
      if args.empty? and block
        JSTP::Registry.instance.set block

        ::EventMachine.run &JSTP::EventMachine
      else
        Connector.instance.dispatch args.first
      end
    end

    def port number
      Connector.instance.port = number
    end
  end
end
