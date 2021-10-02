module Podium
  module PodletPreview
    def self.register(name)
      podlets << name
    end

    def self.podlets
      @podlets ||= []
    end
  end
end
