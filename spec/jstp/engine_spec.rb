require 'spec_helper'

describe JSTP::Engine do 
  describe '#dispatch' do 
    context 'a valid Dispatch aimed at this host' do
      context 'the target class and method exist' do  
        before do 
          JSTP.config do |c|
            c.hostname = 'rspec.tests'
            c.logger = Logger.new $stdout
            c.logger.level = Logger::FATAL
            c.environment :production
          end

          @dispatch = JSTP::Dispatch.new :get, "rspec.tests/User"
        end
        
        it 'should call the method in the target class' do 
          class Eng < JSTP::Engine
            class User < JSTP::Controller
              def get
              end
            end
          end

          Eng::User.any_instance.should_receive :get

          eng = Eng.new :test
          dummy_client = stub 'client'
          eng.dispatch @dispatch, dummy_client
        end
      end
    
      context 'the target class does not exist' do
        it 'should run the method in the engine'
      end
    end
  end
end