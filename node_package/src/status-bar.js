const STATUS_CHANNEL = 'Parcel::StatusChannel'

class StatusBar {
  constructor(settings = {}) {
    this.settings = settings

    this.settings.cable.subscriptions.create(STATUS_CHANNEL, {
      connected: () => {
        this.write(this.settings.log.message, this.settings.log.status)
      },
      received: (log) => {
        if (this.settings.strategies[log.extension] !== 'off') {
          this.settings.updateLog(log)
          this.write(log.message, log.status)
        }
      },
      disconnected: () => {
        this.write('Disconnected from server...', 'error')
      }
    })
  }

  init() {
    let eventName

    if (this.settings.turbolinksEnabled()) {
      eventName = 'turbolinks:load'
    } else if (this.settings.wiselinksEnabled()) {
      eventName = 'page:done'
    } else {
      eventName = 'DOMContentLoaded'
    }

    document.addEventListener(eventName, () => {
      this.render()
      this.write(this.settings.log.message, this.settings.log.status)
    })

    window.Parcel.StatusBar = this
  }

  write(message, status) {
    const log = document.getElementById('parcel-message-log')
    if (log) {
      log.innerHTML = message
      log.className = `parcel-message-log-${status}`
    }
  }

  handleClick(option) {
    this.settings.updateStrategies(option)
    const reloaders = document.getElementById('parcel-reloaders')
    reloaders.innerHTML = this.renderReloaders()
  }

  render() {
    const statusBar = document.getElementById('parcel-status-bar')

    if (statusBar) { document.body.removeChild(statusBar) }

    const sb = document.createElement('DIV')
    sb.setAttribute('class', 'parcel-status-bar')
    sb.setAttribute('id', 'parcel-status-bar')

    sb.innerHTML = `
      ${this.stylesheet()}
      <div id="parcel-reloaders" class="parcel-reloaders">
        ${this.renderReloaders()}
      </div>
      <div id="parcel-message-log">
      </div>
   `

    document.body.appendChild(sb)
  }

  renderReloaders() {
    return (`
      <div class="parcel-reloader">
        <span>js: </span><span class="parcel-type">${this.settings.strategies.js}</span>
        <div class="parcel-menu">
          ${this.renderLink('js', 'page', 'Page Reload')}
          ${this.renderLink('js', 'off', 'Off')}
        </div>
      </div>

      <div class="parcel-reloader">
        <span>css: </span><span class="parcel-type">${this.settings.strategies.css}</span>
        <div class="parcel-menu">
          ${this.renderLink('css', 'page', 'Page Reload')}
          ${this.renderLink('css', 'hot', 'Hot Reload')}
          ${this.renderLink('css', 'off', 'Off')}
        </div>
      </div>
      <div class="parcel-reloader">
        <span>html: </span><span class="parcel-type">${this.settings.strategies.html}</span>
        <div class="parcel-menu">
          ${this.renderLink('html', 'page', 'Page Reload')}
          ${this.renderLink('html', 'turbolinks', 'Turbolinks Reload', this.settings.turbolinksEnabled())}
          ${this.renderLink('html', 'wiselinks', 'Wiselinks Reload', this.settings.wiselinksEnabled())}
          ${this.renderLink('html', 'off', 'Off')}
        </div>
      </div>

      <div class="parcel-reloader">
        <span>ruby: </span><span class="parcel-type">${this.settings.strategies.rb}</span>
        <div class="parcel-menu">
          ${this.renderLink('rb', 'page', 'Page Reload')}
          ${this.renderLink('rb', 'turbolinks', 'Turbolinks Reload', this.settings.turbolinksEnabled())}
          ${this.renderLink('rb', 'wiselinks', 'Wiselinks Reload', this.settings.wiselinksEnabled())}
          ${this.renderLink('rb', 'off', 'Off')}
        </div>
      </div>
    `)
  }

  renderLink(type, strategy, text, enabled = true) {
    const active = this.settings.strategies[type] === strategy

    if (!enabled) {
      return ''
    }

    return (`
      <a
        class="parcel-menu-option ${active ? 'parcel-active' : ''}"
        onclick="Parcel.StatusBar.handleClick({'${type}': '${strategy}'}); return false;"
        href="#"
      >
        <div class="parcel-toggle"></div><div>${text}</div>
      </a>
    `)
  }

  stylesheet() {
    return (`
      <style>
        .parcel-status-bar {
          align-items: center;
          background-color: #1f1f1f;
          ${this.settings.statusBarLocation}: 0;
          color: #999;
          font-family: monospace;
          font-size: 12px;
          display: flex;
          height: 30px;
          position: fixed;
          width: 100%;
        }

        .parcel-status-bar .parcel-reloaders {
          align-items: center;
          display: flex;
        }

        .parcel-status-bar .parcel-reloader {
          border-left: 1px solid #444;
          padding: 4px 8px;
          position: relative;
        }

        .parcel-status-bar .parcel-reloader:hover {
          cursor: pointer;
        }

        .parcel-status-bar .parcel-reloader:hover .parcel-menu {
          display: block;
        }

        .parcel-status-bar .parcel-type {
          color: #eee;
        }

        .parcel-status-bar .parcel-menu {
          background-color: #1f1f1f;
          border-radius: 2px;
          ${this.settings.statusBarLocation}: 22px;
          display: none;
          left: 0;
          position: absolute;
          width: 225px;
        }

        .parcel-status-bar .parcel-menu-option {
          align-items: center;
          border-bottom: 1px solid #000;
          border-top: 1px solid #333;
          color: #999;
          display: flex;
          padding: 6px 15px;
          z-index: 1000;
        }

        .parcel-status-bar .parcel-menu-option:hover {
          background-color: #333;
          text-decoration: none;
        }

        .parcel-status-bar .parcel-active {
          color: #eee;
        }

        .parcel-status-bar .parcel-active .parcel-toggle {
          background-color: #539417;
        }

        .parcel-status-bar .parcel-toggle {
          background-color: #000;
          border-radius: 50%;
          height: 8px;
          margin-right: 8px;
          width: 8px;
        }

        .parcel-status-bar .parcel-message-log-success {
          align-items: center;
          background-color: #539417;
          color: #fff;
          display: flex;
          flex-grow: 1;
          height: 30px;
          padding: 0 8px;
        }

        .parcel-status-bar .parcel-message-log-error {
          align-self: ${this.settings.statusBarLocation === 'bottom' ? 'flex-end' : 'flex-start'};
          background-color: #a93131;
          color: #fff;
          flex-grow: 1;
          min-height: 30px;
          padding: 5px 8px;
          white-space: pre-wrap;
        }
      </style>
    `)
  }
}

module.exports = StatusBar
