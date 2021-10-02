module Podium
  class Client
    attr_reader :podlet_mapping

    def initialize(name_to_url: nil)
      @name_to_url = name_to_url
      @podlet_mapping = {}
      @resources = {}
    end

    def register(name, uri = nil)
      uri ||= determine_uri(name)
      podlet_mapping[name] = uri
    end

    def load_content_for_podlets(podlet_names, context)
      podlet_resources(podlet_names).reduce({}) do |acc, resource|
        acc[resource.name] = resource.fetch(context)
        acc
      end
    end

    def podlet_resources(names)
      names.map { |name| resources[name] ||= Resource.new(podlet_uri(name), name) }
    end

    private

    attr_reader :name_to_url, :resources

    def determine_uri(name)
      raise "name_to_url not specified, podlet must be registered with uri" unless name_to_url
      str = name_to_url.call(name)
      raise "name_to_url returned nil, must return a string" unless str
      URI(str)
    end

    def podlet_uri(name)
      podlet_mapping.fetch(name)
    end
  end
end
