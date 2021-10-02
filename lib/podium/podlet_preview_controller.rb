module Podium
  class PodletPreviewController < ActionController::Base
    def index
      @podlets = Podium::PodletPreview.podlets
      links = @podlets.map do |podlet|
        name = podlet.to_s.underscore
        %(<li><a href="#{podlet_preview_path}/#{name.dasherize}"> #{name.humanize}</a></li>)
      end.join("\n")
      render html: <<-HTML.html_safe
        <h1>Podlet Preview</h1>
        <ul>
          #{links}
        </ul>
      HTML
    end

    private

    def podlet_resource(name, uri: nil)
      podium_name = name.to_s.dasherize
      uri ||= URI(request.url).tap { |u| u.path = "/#{podium_name}" }

      Podium::Resource.new(uri, podium_name)
    end
  end
end
