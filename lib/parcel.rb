require "parcel/version"

require "parcel/parcel_watcher"
require "parcel/compilation_listener"
require "parcel/live_reload_channel"
require "parcel/manifest"
require "parcel/helper"
require "parcel/local_environment"
require "parcel/status_channel"

module Parcel
  STATUS_CHANNEL = "parcel_status".freeze
  RELOAD_CHANNEL = "parcel_live_reload".freeze
end

require "parcel/railtie" if defined?(::Rails)
