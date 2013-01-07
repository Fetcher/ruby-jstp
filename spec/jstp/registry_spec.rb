# -*- encoding : utf-8 -*-
require 'spec_helper'

describe JSTP::Registry do 
  it 'should be a Singleton' do 
    JSTP::Registry.ancestors.should include Singleton
  end

  describe '#get' do 
    it 'should return the registered block' do 
      @data = stub 'data'
      JSTP::Registry.instance.set @data
      JSTP::Registry.instance.get.should == @data
    end
  end

  describe '#set' do 
    it 'should set the block in the registry' do 
      @data = stub 'data'
      JSTP::Registry.instance.set @data
      JSTP::Registry.instance.get.should == @data
    end
  end
end
