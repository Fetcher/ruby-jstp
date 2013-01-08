require 'spec_helper'

describe JSTP::TCP do 
  it 'should be a singleton' do 
    JSTP::TCP.ancestors.should include Singleton
  end
end