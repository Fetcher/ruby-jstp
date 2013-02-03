class Article < JSTP::Resource
  def get
  end
end

class Blog < JSTP::Resource
  resource Article # Declaratively set Article as a resource within Blog
end

Blog.new # Starts Blog as the engine

# The JSTP::Resource class its a combination of Engine and Controller