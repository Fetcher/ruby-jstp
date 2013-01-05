module JSTP
  Server = proc { |websocket|
    websocket.onmessage &Event::OnMessage
  }
end