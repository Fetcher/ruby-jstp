# -*- encoding : utf-8 -*-
require 'spec_helper'

describe JSTP::Connector do 
  it 'should be a singleton' do 
    JSTP::Connector.ancestors.should include Singleton
  end

  it 'should include a discoverer for Writer' do
    JSTP::Connector.ancestors.should include Discoverer::Writer 
  end

  it 'should include a discoverer for Reader' do 
    JSTP::Connector.ancestors.should include Discoverer::Reader
  end
end
