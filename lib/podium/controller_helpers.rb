module Podium
  module ControllerHelpers
    def self.included(base)
      base.before_action :load_podlet_content
      base.helper_method :podlet_content!
    end

    def podlet_content!(name)
      @podlet_content.fetch(name).html_safe
    end

    def load_podlet_content
      @podlet_content = Podium.instance.load_content_for_podlets(podlets, podlet_context)
    end

    def podlet_context
      {}
    end
  end
end
