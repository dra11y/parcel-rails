const LiveReloader = require('./live-reload')
const StatusBar = require('./status-bar')
const Settings = require('./settings')

const ParcelRails = {
  init(options = {}) {
    window.Parcel = (window.Parcel || {})

    const settings = new Settings(options)
    const liveReloader = new LiveReloader(settings)
    const statusBar = new StatusBar(settings)

    liveReloader.init()
    statusBar.init()
  }
}

module.exports = ParcelRails

