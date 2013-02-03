resource :Boat do 
  get do
    # Something
  end
end

resource :Dock do 
  put do 
    get Boat, "cool other data"
  end
end