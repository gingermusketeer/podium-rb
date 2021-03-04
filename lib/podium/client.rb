module Podium
  class Client
    def register(uri)
      Resource.new(uri)
    end
  end
end
