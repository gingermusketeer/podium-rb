module Podium
  class Configuration
    attr_reader :podlets

    attr_writer :name_to_url

    def initialize
      @podlets = {}
    end

    def register(name, url = nil)
      @podlets[name] = url
    end

    def name_to_url
      @name_to_url || ->(name) { raise "name_to_url not configured. Set name_to_url in podium configuration." }
    end
  end
end
