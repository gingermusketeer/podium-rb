require "rails/generators"

module Podium
  class PodletGenerator < ::Rails::Generators::NamedBase
    APP_CONTROLLER_PATH = "app/controllers/application_controller.rb"
    PREVIEW_CONTROLLER_PATH = "app/controllers/podlet_preview_controller.rb"
    LAYOUT_PATH = "app/views/layouts/application.html.erb"

    source_root File.expand_path("templates", __dir__)

    desc "Generate boilerplate for a podlet"

    def create_controller
      template "podlet_controller.rb", "app/controllers/#{controller_file_name}"
    end

    def create_views
      template "content.html.erb", "app/views/#{folder_name}/content.html.erb"
    end

    def prepare_assets
      create_file "app/assets/javascripts/#{folder_name}/podlet.js"
      create_file "app/assets/stylesheets/#{folder_name}/podlet.css"
      return if contents("app/assets/config/manifest.js").include?(folder_name)
      append_to_file "app/assets/config/manifest.js", "//= link_directory ../javascripts/#{folder_name} .js\n"
      append_to_file "app/assets/config/manifest.js", "//= link_directory ../stylesheets/#{folder_name} .css\n"
    end

    def setup_routes
      route = "podlet :#{podlet_name}"
      return if route_present?(route)
      if route_present?("podlet_preview")
        inject_into_file "config/routes.rb", "\n  #{route}", before: "\n  podlet_preview"
      else
        inject_into_file "config/routes.rb", "\n  #{route}", before: "\nend"
        inject_into_file "config/routes.rb", "\n  podlet_preview if Rails.env.development?", before: "\nend"
      end
    end

    def setup_preview
      unless preview_exists?
        template "podlet_preview_controller.rb", PREVIEW_CONTROLLER_PATH
      end
      return if contents(PREVIEW_CONTROLLER_PATH).include?(podlet_name)

      podlet_action = <<-RUBY
\ndef #{podlet_name}
  resource = podlet_resource(:#{podlet_name})
  render html: resource.fetch({}).html_safe
end
      RUBY

      inject_into_file PREVIEW_CONTROLLER_PATH, podlet_action, before: "\nend"
    end

    private

    def preview_exists?
      inside do
        return File.exist?(PREVIEW_CONTROLLER_PATH)
      end
    end

    def route_present?(route)
      contents("config/routes.rb").include?(route)
    end

    def contents(path)
      inside do
        return File.read(path)
      end
    end

    def folder_name
      "#{podlet_name}_podlet"
    end

    def podlet_name
      name.underscore
    end

    def controller_file_name
      "#{controller_name.underscore}.rb"
    end

    def controller_name
      "#{name.underscore.camelcase}PodletController"
    end
  end
end
