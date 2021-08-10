require "rails"

module Parcel
  class StatusChannel < ::ActionCable::Channel::Base
    def subscribed
      stream_from "parcel_status"
    end
  end
end
