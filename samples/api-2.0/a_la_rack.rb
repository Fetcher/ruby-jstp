resource :User do 
  get do 
    # Something
  end

  delete do 
    # Something
  end

  resource :Rating do 
    put do 
    end
  end
end

resource :Article do 
  get do 
    # Something with article
  end

  resource User # Includes User here. Along with Rating within
end