require "rails"

module Parcel
  class LiveReloadChannel < ::ActionCable::Channel::Base
    def subscribed
      stream_from "parcel_live_reload"
    end
  end
end
