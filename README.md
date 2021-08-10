<p align="center">
  <img alt="Parcel logo" src="https://parceljs.org/assets/parcel-og.png" height="200" style="vertical-align: middle" />
  <img alt="Ruby on Rails logo" src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Ruby_On_Rails_Logo.svg/1200px-Ruby_On_Rails_Logo.svg.png" height="75" style="vertical-align: middle" />
</p>

# Parcel on Rails

## NOTE: I just forked and started working on this gem (August 10, 2021) & will update when I get it working.

[Parcel-Rails](https://github.com/dra11y/parcel-rails) integrates modern Javascript
tooling into your Rails project. Powered by [Parcel](https://parceljs.org).

Get support for ES6 syntax & modules, live reload for CSS, JS, & HTML, and Yarn
support. Be up and running on the latest frontend framework in minutes.

## Installation & Usage

View updates in the [CHANGELOG](https://github.com/dra11y/parcel-rails/blob/master/CHANGELOG.md)

## Forked [Breakfast](http://breakfast.devlocker.io) History

### (as of August 10, 2021)

### Latest Patch `0.6.6`

#### Fixed

- Support Rails 6 by removing constraint on ActionCable

  [@mattr](https://github.com/devlocker/parcel/pull/32)

### Latest Release `0.6.0`

#### Fixed

- Puma hanging in clustered mode. Parcel would fail to cleanly exit on Puma
  exit, causing the server to hang indefinitely.
- Bumped Rails version dependency, can be used with Rails 5.0 and greater.
  (Allows usage with Rails 5.1)

#### Removed

- Capistrano rake tasks. Previous behavior has been included into the Rails
  asset:precompile task. Using the standard [Capistrano Rails](https://github.com/capistrano/rails)
  gem is all that required now.
- Need for a custom Heroku buildpack.

### Upgrading

#### Upgrading to `0.6.0` from `0.5.x`

- Update gem with `bundle update parcel`
- Update the JS package with `yarn upgrade parcel-rails`
- If deploying with Capistrano, remove `require "parcel/capistrano"` from
  your `Capfile`. Remove any custom Parcel settings from `config/deploy.rb`.
  Ensure that you are using [Capistrano Rails](https://github.com/capistrano/rails)
  and have `require 'capistrano/rails'` or `require 'capistrano/rails/assets'`
  in your `Capfile`.
- If deploying with Heroku, run the following commands:
  1.  heroku buildpacks:clear
  2.  heroku buildpacks:set heroku/nodejs --index 1
  3.  heroku buildpacks:set heroku/ruby --index 2

_Note_ If you are deploying with Capistrano then Yarn is expected to be
installed on the hosts your are deploying to.

### Changes

See list of changes between versions in the CHANGELOG

### Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/dra11y/parcel-rails.

### Thanks

Special thanks to Patrick Koperwas & contributors for the original
[Breakfast](http://breakfast.devlocker.io) gem that this
gem was forked from.

### License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
