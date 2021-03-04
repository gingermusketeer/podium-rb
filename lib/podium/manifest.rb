module Podium
  class Manifest
    attr_reader :name, :version, :content, :fallback, :assets, :css, :js, :proxy

    def initialize(data)
      @name = data.fetch("name")
      @version = data.fetch("version")
      @content = data.fetch("content")
      @fallback = data.fetch("fallback")
      @assets = data.fetch("assets")
      @css = data.fetch("css")
      @js = data.fetch("js")
      @proxy = data.fetch("proxy")
    end
  end
end
