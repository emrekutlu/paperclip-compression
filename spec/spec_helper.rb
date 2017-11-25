require 'bundler/setup'
Bundler.setup

# We need this because of this https://github.com/thoughtbot/paperclip/pull/2369
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/try'
require 'paperclip-compression'

RSpec.configure do |config|
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
  config.order = :random
end
