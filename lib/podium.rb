# frozen_string_literal: true

require "podium/version"
require "podium/client"
require "podium/resource"
require "podium/manifest"
require "podium/configuration"
require "podium/controller_helpers"
require "podium/podlet_preview"
require "podium/podlet_helpers"
require "podium/core_ext"

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
