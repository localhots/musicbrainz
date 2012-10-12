require "rubygems"
require "bundler/setup"
require "musicbrainz"

MusicBrainz.configure do |c|
  test_email = %x{ git config --global --get user.email }.gsub(/\n/, "")
  test_email = "magnolia_fan@me.com" if test_email.empty?

  c.app_name = "MusicBrainzGemTestSuite"
  c.app_version = MusicBrainz::VERSION
  c.contact = test_email
  c.perform_caching = true
end

RSpec.configure do |config|
  # Configuration is not currently necessary
end
