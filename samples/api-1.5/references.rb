resource :Useful do 
  delete do 
    # Do something
  end
end

resource :Node do 
  put do 
    get 'other.host/Node', data: "this goes in the body"
    delete Useful, id: "this goes to self"
  end
end