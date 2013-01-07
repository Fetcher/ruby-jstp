# -*- encoding : utf-8 -*-
module JSTP
  EventMachine = proc {
    JSTP::Connector.instance.server
  }
end
