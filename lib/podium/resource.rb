require "net/http"
require "json"

module Podium
  class Resource
    class VersionMismatchError < StandardError
      def initialize(podlet_version, manifest_version)
        super("expected podlet_version=#{podlet_version} to match manifest_version=#{manifest_version}")
      end
    end

    attr_reader :uri

    def initialize(uri)
      @uri = uri
    end

    def manifest
      @manifest ||= fetch_manifest
    end

    def fetch
      response = Net::HTTP.get_response(content_uri)
      check_podlet_version!(response["podlet-version"])
      response.body
    end

    private

    def check_podlet_version!(version)
      return if version == manifest.version

      raise VersionMismatchError.new(version, manifest.version)
    end

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
