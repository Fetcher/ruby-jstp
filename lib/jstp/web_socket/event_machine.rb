# -*- encoding : utf-8 -*-
module JSTP
  module WebSocket
    EventMachine = proc {
      JSTP::Connector.instance.server
    }
  end
end
