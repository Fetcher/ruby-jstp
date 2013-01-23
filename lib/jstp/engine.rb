module JSTP
  class Engine
    include Singleton
    
    # Processes the dispatch in the new REST engine way
    def dispatch message
      resource = eval(message["resource"][1]).new message
      if message["body"].nil? || message["body"].empty?
        resource.send message["method"].downcase.to_sym
      else
        resource.send(
            message["method"].downcase.to_sym, 
            {"body" => message["body"]}
          )
      end
    end
  end
end