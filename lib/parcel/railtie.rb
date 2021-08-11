require "rails"
require "fileutils"
require "listen"

module Parcel
  class Railtie < ::Rails::Railtie
    config.parcel = ActiveSupport::OrderedOptions.new

    config.before_configuration do |app|
      config.parcel.html_reload_strategy = :turbolinks
      config.parcel.js_reload_strategy = :page
      config.parcel.css_reload_strategy = :hot
      config.parcel.ruby_reload_strategy = :off

      config.parcel.asset_output_folder = ::Rails.root.join('public/assets')
      config.parcel.source_code_folders = [::Rails.root.join('app')]
      config.parcel.environments = %w(development)
      config.parcel.status_bar_location = :bottom
      config.parcel.digest = !(::Rails.env.development? || ::Rails.env.test?)

      config.parcel.version = 1 # TODO: get working with parcel v2, after parcel 2 works with Vue 2!
      config.parcel.entrypoint_folders = %w[app/packs/entrypoints app/javascript/packs]
      # parcel@1.12.3:
      config.parcel.bin_path = './node_modules/parcel/bin/cli.js'

      # parcel@1 minify is broken; we will use our own
      # and pass --no-minify to parcel CLI:
      config.parcel.replace_minify = true
    end

    initializer "parcel.setup_view_helpers" do |app|
      ActiveSupport.on_load(:action_view) do
        include ::Parcel::Helper
      end
    end

    rake_tasks do
      load "tasks/parcel.rake"
    end

    config.after_initialize do |app|
      if config.parcel.digest
        config.parcel.manifest = Parcel::Manifest.new(base_dir: config.parcel.asset_output_folder)
      end

      if config.parcel.environments.include?(::Rails.env) && Parcel::LocalEnvironment.new.running_server?

        # Ensure public/assets directory exists
        FileUtils.mkdir_p(::Rails.root.join("public", "assets"))

        # Start Parcel Process
        @parcel = Parcel::ParcelWatcher.new(log: ::Rails.logger, config: config)
        Thread.start do
          @parcel.run
        end

        at_exit do
          @parcel.terminate
        end

        # Setup file listeners
        Parcel::CompilationListener.start(
          asset_output_folder: config.parcel.asset_output_folder,
          source_code_folders: config.parcel.source_code_folders
        )
      end
    end

    ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES[:javascript] = "/assets"
    ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES[:image] = "/assets"
    ActionView::Helpers::AssetUrlHelper::ASSET_PUBLIC_DIRECTORIES[:stylesheet] = "/assets"
  end
end
