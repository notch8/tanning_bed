require 'spec'

__DIR__ = File.dirname(__FILE__) + "/"

# Require libraries
Dir.glob(__DIR__ + "../lib/**.rb").each do |file|
  require file
end

require __DIR__ + "fixtures/tanning_model.rb"
