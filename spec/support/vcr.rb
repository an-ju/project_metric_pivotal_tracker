require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<PIVOTAL_TRACKER_API_TOKEN>") { ENV['PIVOTAL_TRACKER_API_TOKEN'] }
end
