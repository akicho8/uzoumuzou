$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'uzoumuzou'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
