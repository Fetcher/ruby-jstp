# -*- encoding : utf-8 -*-
module JSTP
  module WebSocket
    Server = proc { |websocket|
      websocket.onmessage &Event::OnMessage
    }
  end
end
