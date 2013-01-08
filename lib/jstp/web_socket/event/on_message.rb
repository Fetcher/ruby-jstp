# -*- encoding : utf-8 -*-
module JSTP
  module WebSocket
    module Event
      OnMessage = proc { |message|
        JSTP::Connector.instance.block.call JSON.parse message
      }
    end
  end
end
