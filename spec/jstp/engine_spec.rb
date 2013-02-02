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
    
      context 'the target class exists but is not a JSTP::Controller' do 
        before do
          JSTP.config do |c|
            c.hostname 'rspec.tests'
            c.logger Logger.new $stdout
            c.logger.level = Logger::FATAL
            c.environment :production
          end

          class Eng < JSTP::Engine
            class Article
            end
          end

          @dispatch = JSTP::Dispatch.new :put, "rspec.tests/Article"
        end

        it 'should raise an opaque error about the resource being invalid' do 
          Eng::Article.any_instance.should_not_receive :put

          eng = Eng.new :test
          dummy_client = stub 'client'
          expect {
            eng.dispatch @dispatch, dummy_client
          }.to raise_error JSTP::Engine::NotPermittedError, 
            "The selected resource is forbidden for this type of request"
        end

        context 'while in development mode' do 
          before do 
            JSTP.config do |c|
              c.environment :development
            end
          end

          it 'should raise a relevant error' do 
            Eng::Article.any_instance.should_not_receive :put

            eng = Eng.new :test
            dummy_client = stub 'client'

            expect {
              eng.dispatch @dispatch, dummy_client
            }.to raise_error JSTP::Engine::NotAControllerError,
              "The resource class Eng::Article for rspec.tests/Article was found, but is not a JSTP::Controller"
          end
        end
      end

      context 'the target class does not exist' do
        it 'should run the method in the engine'
      end
    end
  end
end