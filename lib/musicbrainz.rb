# -*- encoding: utf-8 -*-
require "open-uri"
require "socket"
require "nokogiri"
require "cgi"

module MusicBrainz
  module Tools
  end
  module Parsers
  end
end

require "version"
require "deprecated"

require "musicbrainz/base"
require "musicbrainz/artist"
require "musicbrainz/release_group"
require "musicbrainz/release"
require "musicbrainz/track"

require "tools/cache"
require "tools/proxy"

require "parsers/base"
require "parsers/artist"
require "parsers/release_group"
require "parsers/release"
require "parsers/track"
