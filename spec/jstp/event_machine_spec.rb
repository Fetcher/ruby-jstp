# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'JSTP::EventMachine' do 
  it 'should ask the connector to initialize the server' do 
    JSTP::Connector.instance.should_receive(:server)

    JSTP::EventMachine.call
  end
end
