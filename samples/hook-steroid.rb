require 'jstp'

class Eng < JSTP::Engine
  def open client, token
    logger.info "Open #{token}"
  end

  def close client, token
    logger.warn "Close #{token}" 
  end

  class User < JSTP::Controller
    def get
      engine.logger.info query.first
    end
  end
end