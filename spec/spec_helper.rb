if ENV['COVERAGE_REPORT']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require "rubygems"
require "bundler/setup"
require "musicbrainz"

Dir[File.expand_path('./spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |c|
  c.order = 'random'
end

MusicBrainz.configure do |c|
  test_email = `git config user.email`.chomp
  test_email = "magnolia_fan@me.com" if test_email.empty?

  c.app_name = "MusicBrainzGemTestSuite"
  c.app_version = MusicBrainz::VERSION
  c.contact = test_email

  c.cache_path = File.join(File.dirname(__FILE__), '..', 'tmp', 'spec_cache')
  c.perform_caching = true
  c.hexdigest_url = false
end
