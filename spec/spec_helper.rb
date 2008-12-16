# $Id$
require 'spec'

__DIR__ = File.dirname(__FILE__) + "/"

require File.expand_path(
    File.join(File.dirname(__FILE__), %w[.. lib tanning_bed]))

require __DIR__ + "fixtures/tanning_model.rb"
require __DIR__ + "fixtures/burnt_model.rb"

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

# EOF
