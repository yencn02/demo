RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
Bundler.setup(:default)

Rails::Initializer.run do |config|
  # All gem dependencies are now handled by Bundler.
  # Look in the file Gemfile in order to see the Gem dependencies.

  config.time_zone = 'UTC'
  config.action_controller.session_store = :active_record_store
  config.action_controller.session = {
    :key => "_vafitness",
    :secret => "3dc2d8ba4dd29c7b229bed0f8e396ba7126a9e7d50b386aec2c3752030d5582a2cb22f84be3753d914fb7cf56b0ca8e8bfb4805b759b93f10ff4a2dc835abedd"
  }
end

# Set the default currency to US Dollars
Money.default_currency = 'USD'
