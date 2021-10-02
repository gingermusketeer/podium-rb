module ActionDispatch
  module Routing
    class Mapper
      def podlet(name)
        Podium::PodletPreview.register(name)
        prefix = "#{name}_podlet"
        scope name.to_s.dasherize, as: prefix do
          get "/", to: "#{prefix}#content", as: "content"
          get "/fallback", to: "#{prefix}#fallback"
          get "/manifest.json", to: "#{prefix}#manifest", as: "manifest"
        end
      end

      def podlet_preview
        scope "podlet-preview" do
          get "/", to: "podlet_preview#index", as: "podlet_preview"

          Podium::PodletPreview.podlets.each do |name|
            get "/#{name.to_s.dasherize}", to: "podlet_preview##{name}"
          end
        end
      end
    end
  end
end
