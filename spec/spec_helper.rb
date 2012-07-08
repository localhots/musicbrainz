# -*- encoding: utf-8 -*-

require "rubygems"
require "bundler/setup"
require "ap"

require "musicbrainz"

MusicBrainz::Tools::Cache.cache_path = "tmp/cache"

RSpec.configure do |config|
  # Configuration is not currently necessary
end
