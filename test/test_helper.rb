$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alpha_hang'

require 'minitest/autorun'

begin
  require 'minitest/focus'
rescue LoadError
end

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end
