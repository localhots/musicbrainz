# -*- encoding: utf-8 -*-
require "open-uri"
require "socket"
require "nokogiri"
require "cgi"

require "version"

module MusicBrainz
  autoload :Base, "musicbrainz/base"
  autoload :Artist, "musicbrainz/artist"
  autoload :ReleaseGroup, "musicbrainz/release_group"
  autoload :Release, "musicbrainz/release"
  autoload :Track, "musicbrainz/track"

  module Tools
    autoload :Cache, "tools/cache"
    autoload :Proxy, "tools/proxy"
  end
end
