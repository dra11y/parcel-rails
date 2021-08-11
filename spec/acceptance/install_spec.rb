require "spec_helper"
require "tmpdir"

RSpec.describe "Installing the Gem" do
  describe "Using generator" do
    specify do
      rails_dir = Dir.mktmpdir

      %x{rails new #{rails_dir}}

      open("#{rails_dir}/Gemfile", "a") do |file|
        file.write("gem 'parcel', path: '#{Dir.pwd}'")
      end

      %x{cd #{rails_dir} && bundle install}
      %x{cd #{rails_dir} && bundle exec rails generate parcel:install}
      %x{cd #{rails_dir} && node_modules/parcel/bin/parcel build}

      expect(File).to exist("#{rails_dir}/parcel-config.js")
      expect(File).to exist("#{rails_dir}/package.json")
      expect(File).to exist("#{rails_dir}/app/frontend/js/app.js")
      expect(File).to exist("#{rails_dir}/app/frontend/css/app.scss")
      expect(File.directory?("#{rails_dir}/node_modules")).to be true
      expect(File).to exist("#{rails_dir}/public/assets/app.css")
      expect(File).to exist("#{rails_dir}/public/assets/app.js")
    end
  end
end
