module Parcel
  module Helper
    def parcel_autoreload_tag
      if ::Rails.configuration.parcel.environments.include?(::Rails.env)
        content_tag :script do
          <<-SCRIPT.html_safe
            require("parcel-rails").init({
              host: "#{request.host}",
              port: #{request.port},
              strategies: {
                js: "#{::Rails.configuration.parcel.js_reload_strategy}",
                css: "#{::Rails.configuration.parcel.css_reload_strategy}",
                html: "#{::Rails.configuration.parcel.html_reload_strategy}",
                rb: "#{::Rails.configuration.parcel.ruby_reload_strategy}"
              },
              statusBarLocation: "#{::Rails.configuration.parcel.status_bar_location}"
            });
          SCRIPT
        end
      end
    end

    include ActionView::Helpers::AssetUrlHelper
    include ActionView::Helpers::AssetTagHelper

    def compute_asset_path(path, options = {})
      if ::Rails.configuration.parcel.digest && ::Rails.configuration.parcel.manifest.asset(path)
        path = ::Rails.configuration.parcel.manifest.asset(path)
      end

      super(path, options)
    end
  end
end
