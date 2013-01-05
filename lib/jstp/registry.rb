module JSTP
  class Registry
    include Singleton

    def set block
      @block = block
    end

    def get
      @block
    end
  end
end