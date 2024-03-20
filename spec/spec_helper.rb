require "rubygems"
require "bundler/setup"
require "musicbrainz"
require "pry"
require "awesome_print"
require_relative 'support/mock_helpers'

RSpec.configure do |c|
  include MockHelpers
  c.order = 'random'
end

MusicBrainz.configure do |c|
  test_email = `git config user.email`.chomp
  raise 'Configure user.email in Git before running tests' if test_email.empty?

  c.app_name = "MusicBrainzGemTestSuite"
  c.app_version = MusicBrainz::VERSION
  c.contact = test_email

  c.cache_path = File.join(File.dirname(__FILE__), '..', 'tmp', 'spec_cache')
  c.perform_caching = true
end
