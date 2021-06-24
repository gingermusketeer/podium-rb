require "net/http"
require "json"

module Podium
  class Resource
    class VersionMismatchError < StandardError
      def initialize(podlet_version, manifest_version)
        super("expected podlet_version=#{podlet_version} to match manifest_version=#{manifest_version}")
      end
    end

    HTTP_OPTS = {
      open_timeout: 5,
      read_timeout: 5,
      write_timeout: 5,
      ssl_timeout: 5,
    }

    attr_reader :uri, :name

    def initialize(uri, name)
      @uri = uri
      @name = name
    end

    def manifest
      @manifest ||= fetch_manifest
    end

    def fetch(context = {})
      response = make_request(content_uri, context)
      check_podlet_version!(response["podlet-version"])
      response.body.force_encoding("UTF-8")
    end

    private

    def check_podlet_version!(version)
      return if version == manifest.version

      raise VersionMismatchError.new(version, manifest.version)
    end

    def fetch_manifest
      Manifest.new(JSON.parse(make_request(manifest_uri, {}).body))
    end

    def make_request(uri, context)
      response = Net::HTTP.start(uri.host, uri.port, HTTP_OPTS) do |http|
        request = Net::HTTP::Get.new uri
        context.compact.each do |k, v|
          header = "podium-#{k.to_s.gsub("_", "-")}"
          request[header] = v
        end

        http.request(request)
      end
      raise StandardError, "Non 200 response from podlet" if response.code != "200"
      response
    end

    def manifest_uri
      URI("#{uri}/manifest.json")
    end

    def content_uri
      URI("#{uri}#{manifest.content}")
    end
  end
end
