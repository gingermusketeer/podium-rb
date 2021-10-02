module Podium
  module LayoutHelper
    def podlet_content!(name)
      @podlet_content.fetch(name).html_safe
    end

    def podlet_assets(type)
      Podium.instance.podlet_resources(@podlet_content.keys).flat_map do |resource|
        resource.manifest.public_send(type)
      end
    end

    def podlet_js_tags
      podlet_assets(:js).map do |data|
        javascript_tag(nil, src: data.fetch("value"), type: data.fetch("type"))
      end.join("\n").html_safe
    end
  end
end
