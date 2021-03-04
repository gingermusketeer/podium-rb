require "net/http"
require "json"

module Podium
  class Resource
    attr_reader :uri

    def initialize(uri)
      @uri = uri
    end

    def manifest
      @manifest ||= fetch_manifest
    end

    def fetch
      Net::HTTP.get(content_uri)
    end

    private

    def fetch_manifest
      Manifest.new(JSON.parse(Net::HTTP.get(manifest_uri)))
    end

    def manifest_uri
      URI("#{uri}/manifest.json")
    end

    def content_uri
      URI("#{uri}#{manifest.content}")
    end
  end
end
