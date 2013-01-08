# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'JSTP::WebSocket::EventMachine' do 
  it 'should ask the connector to initialize the server' do 
    JSTP::Connector.instance.should_receive(:server)

    JSTP::WebSocket::EventMachine.call
  end
end
