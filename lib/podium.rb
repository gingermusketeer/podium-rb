# frozen_string_literal: true

require_relative "podium/version"
require_relative "podium/client"
require_relative "podium/resource"
require_relative "podium/manifest"
require_relative "podium/configuration"
require_relative "podium/controller_helpers"
require_relative "podium/podlet_preview"
require_relative "podium/podlet_helpers"
require_relative "podium/core_ext"

module Podium
  class NotConfiguredError < StandardError; end

  def self.configuration
    @configuration || (raise NotConfiguredError, "Did you forget to run Podium.configure ?")
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(configuration)
  end

  def self.instance
    @instance ||= build_instance
  end

  def self.build_instance
    client = Podium::Client.new(name_to_url: configuration.name_to_url)
    configuration.podlets.each do |key, url|
      client.register(key, url)
    end
    client
  end
end
