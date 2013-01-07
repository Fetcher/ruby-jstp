# -*- encoding : utf-8 -*-
module JSTP
  module Event
    OnMessage = proc { |message|
      JSTP::Registry.instance.get.call JSON.parse message
    }
  end
end
