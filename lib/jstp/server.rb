# -*- encoding : utf-8 -*-
module JSTP
  Server = proc { |websocket|
    websocket.onmessage &Event::OnMessage
  }
end
