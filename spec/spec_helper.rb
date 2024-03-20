require "rubygems"
require "bundler/setup"
require "musicbrainz"
require "pry"
require "awesome_print"
require_relative 'support/mock_helpers'

RSpec.configure do |c|
  include MockHelpers

  c.order = 'random'
  c.color = true
end

MusicBrainz.configure do |c|
  c.app_name = "MusicBrainzGemTestSuite"
  c.app_version = MusicBrainz::VERSION
  c.contact = "root@localhost"
end
