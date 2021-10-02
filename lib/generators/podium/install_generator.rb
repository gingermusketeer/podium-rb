require "rails/generators"

module Podium
  class InstallGenerator < ::Rails::Generators::Base
    APP_CONTROLLER_PATH = "app/controllers/application_controller.rb"
    LAYOUT_PATH = "app/views/layouts/application.html.erb"

    source_root File.expand_path("templates", __dir__)

    desc "Sets up your application for integrating with podium"

    def copy_initializer
      template "podium.rb", "config/initializers/podium.rb"

      inside do
        setup_app_controller
      end
    end

    def add_podlets_to_layout
      return if File.read(LAYOUT_PATH).include?("podlet_content!")
      inject_into_file LAYOUT_PATH, "<%= podlet_content!(:header) %>\n    ", before: "<%= yield %>"
      inject_into_file LAYOUT_PATH, "    <%= podlet_content!(:footer) %>\n", after: "<%= yield %>\n"
      inject_into_file LAYOUT_PATH, "  <%= podlet_js_tags %>\n  ", before: "</head>\n"
    end

    private

    def setup_app_controller
      return unless File.exists?(APP_CONTROLLER_PATH)

      return if File.read(APP_CONTROLLER_PATH).include?("Podium::ControllerHelpers")

      new_content = <<-'RUBY'
  include Podium::ControllerHelpers

  def podlets
    [:header, :footer]
  end
        RUBY
      inject_into_class APP_CONTROLLER_PATH, "ApplicationController", new_content
    end
  end
end
