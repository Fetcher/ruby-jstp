class Eng < JSTP::Engine
  def open client, token
    # A new client has connected and this gets executed
  end

  def close client, token
    # A client has disconnected and this gets executed 
  end
end