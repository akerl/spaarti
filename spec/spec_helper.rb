require 'rspec'
require 'spaarti'
require 'webmock/rspec'

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.before_record do |i|
    i.request.headers.delete 'Authorization'
    %w[Etag X-Github-Request-Id X-Served-By].each do |header|
      i.response.headers.delete header
    end
  end
end
