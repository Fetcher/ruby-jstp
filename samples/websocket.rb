JSTP.config do |config|
  config.strategy inbound: :websocket
end

class WebS < JSTP::Engine
  class Article < JSTP::Controller
    def post
      puts body
    end
  end
end