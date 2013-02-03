class TokenEmptier < JSTP::Resource
  get do 
    original.token = [] # Not useful, just first thing to cross mind
  end

  all do # Same as def all
    puts "This will be printed everytime" 
  end
end

class App < JSTP::Resource
  use TokenEmptier

  get do 
    # => "This will be printed everytime" 
    # from TokenEmptier#all
    puts token # => nil
  end
end

App.new

# Nice, huh?