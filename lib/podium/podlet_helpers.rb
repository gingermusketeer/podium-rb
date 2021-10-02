module Podium
  module PodletHelpers
    def self.included(base)
      base.layout false
      base.extend(ClassMethods)
      base.before_action :set_podium_headers, only: [:content, :fallback]
    end

    def manifest
      render json: self.class.podlet_manifest.to_json
    end

    def set_podium_headers
      response.set_header("podlet-version", self.class.version)
    end

    def podium_params
      @podium_params ||= ActionController::Parameters.new(podium_header_params)
    end

    def podium_header_params
      request.headers
        .select { |(k)| k.start_with?("HTTP_PODIUM_") }
        .reduce({}) do |acc, (header, value)|
        key = header.gsub("HTTP_PODIUM_", "").underscore
        acc[key] = value
        acc
      end
    end

    module ClassMethods
      def podlet_manifest
        @podlet_manifest ||= {
          name: self.class.name.gsub("PodletController", "").underscore.dasherize,
          version: version,
          content: "/",
          fallback: "/fallback",
          proxy: {},

        }.merge(assets)
      end

      def assets
        {
          assets: {
            js: "",
            css: "",
          },
          js: [],
          css: [],
        }
      end

      def version
        @version ||= ENV.fetch("VERSION", DateTime.now().to_i.to_s)
      end
    end
  end
end
