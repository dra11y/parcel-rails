require "spec_helper"
require "tmpdir"

RSpec.describe Parcel::CompilationListener do
  let!(:asset_dir) { Dir.mktmpdir }
  let!(:source_code_dir) { Dir.mktmpdir }

  before do
    allow(Parcel::CompilationListener).to receive(:broadcast)
  end

  describe ".start" do
    it "will listen for changes to the asset output folder" do
      Parcel::CompilationListener.start(
        asset_output_folder: asset_dir,
        source_code_folders: source_code_dir
      )

      ["css", "js"].each do |extension|
        open("#{asset_dir}/foo.#{extension}", "w")

        sleep(2)

        expect(Parcel::CompilationListener).
          to have_received(:broadcast).with(
            Parcel::RELOAD_CHANNEL,
            { extension: extension }
          )
      end
    end

    it "will listen for changes to the source code folders" do
      Parcel::CompilationListener.start(
        asset_output_folder: asset_dir,
        source_code_folders: source_code_dir
      )

      ["rb", "html", "haml", "slim"].each do |extension|
        open("#{source_code_dir}/foo.#{extension}", "w")

        sleep(2)

        expect(Parcel::CompilationListener).
          to have_received(:broadcast).with(
            Parcel::RELOAD_CHANNEL,
            { extension: extension }
          )

        expect(Parcel::CompilationListener).
          to have_received(:broadcast).with(Parcel::STATUS_CHANNEL, {
            status: "success",
            message: "saved: foo.#{extension}",
            extension: extension
          })
      end
    end
  end
end
