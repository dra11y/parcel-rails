module Parcel
  class CompilationListener
    ASSET_EXTENSIONS = ["css", "js"].freeze
    SOURCE_CODE_EXTENSIONS = ["rb", "html", "haml", "slim"].freeze

    def self.start(asset_output_folder:, source_code_folders:)
      asset_listener =
        ::Listen.to(asset_output_folder) do |modified, added, removed|
          files = modified + added + removed

          ASSET_EXTENSIONS.each do |extension|
            if files.any? { |file| file.match(/\.#{extension}/) }
              broadcast(Parcel::RELOAD_CHANNEL, { extension: extension })
            end
          end
        end

      rails_listener =
        ::Listen.to(*source_code_folders) do |modified, added, removed|
          files = modified + added + removed

          SOURCE_CODE_EXTENSIONS.each do |extension|
            matched = files.select { |file| file.match(/\.#{extension}/) }
            if matched.present?
              broadcast(Parcel::RELOAD_CHANNEL, { extension: extension })

              file_names = matched
                .map { |file| file.split("/").last }
                .join(", ")
                .truncate(60)

              broadcast(Parcel::STATUS_CHANNEL, {
                status: "success",
                message: "saved: #{file_names}",
                extension: extension
              })
            end
          end
        end

      asset_listener.start
      rails_listener.start
    end

    def self.broadcast(channel, data)
      ActionCable.server.broadcast(channel, data)
    end
  end
end
