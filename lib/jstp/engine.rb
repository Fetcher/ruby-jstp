module JSTP
  class Engine
    include Singleton
    
    # Processes the dispatch in the new REST engine way
    def dispatch message
      host, the_class, query = discover_resource message["resource"].clone
      resource = the_class.new message
      if query.empty? && (message["body"].nil? || message["body"].empty?)
        resource.send message["method"].downcase.to_sym
      else
        resource.send(
          message["method"].downcase.to_sym, 
          {
            "body" => message["body"],
            "query" => query
          }
        )
      end
    end

    def discover_resource resource_stack
      response = []
      response << resource_stack.shift
      class_stack = "::"
      query = []
      resource_stack.each do |item|
        begin
          eval(class_stack + item.to_s.capitalize)
          class_stack += "#{item.capitalize}::"
        rescue NameError, SyntaxError
          query << item
        end
      end
      response << eval(class_stack[0..-3])
      response << query
      return response
    end
  end
end