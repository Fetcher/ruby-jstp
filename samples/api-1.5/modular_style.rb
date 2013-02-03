class MyEngine < JSTP::Engine

  strategy.inbound :websocket
  port.inbound 44444
  logger Logger.new $stdout

  resource :user do 
    get do
    end

    post do
    end

    resource :source do
      get do
      end
    end
  end

end

MyEngine.run