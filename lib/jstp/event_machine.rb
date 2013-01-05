module JSTP
  EventMachine = proc {
    JSTP::Connector.instance.server
  }
end