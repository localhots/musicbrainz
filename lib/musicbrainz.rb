require "digest/sha1"
require "fileutils"
require "date"

require "faraday"
require "nokogiri"

require "musicbrainz/version"
require "musicbrainz/deprecated"
require "musicbrainz/middleware"
require "musicbrainz/configuration"

require "musicbrainz/client_modules/transparent_proxy"
require "musicbrainz/client_modules/failsafe_proxy"
require "musicbrainz/client_modules/caching_proxy"
require "musicbrainz/client"

require "musicbrainz/models/base_model"
require "musicbrainz/models/artist"
require "musicbrainz/models/medium"
require "musicbrainz/models/release_group"
require "musicbrainz/models/release"
require "musicbrainz/models/track"
require "musicbrainz/models/recording"

require "musicbrainz/bindings/artist"
require "musicbrainz/bindings/artist_search"
require "musicbrainz/bindings/artist_release_groups"
require "musicbrainz/bindings/discid_releases"
require "musicbrainz/bindings/medium"
require "musicbrainz/bindings/relations"
require "musicbrainz/bindings/release_group"
require "musicbrainz/bindings/release_group_search"
require "musicbrainz/bindings/release_group_releases"
require "musicbrainz/bindings/release"
require "musicbrainz/bindings/release_mediums"
require "musicbrainz/bindings/release_tracks"
require "musicbrainz/bindings/track"
require "musicbrainz/bindings/recording"
require "musicbrainz/bindings/recording_search"

module MusicBrainz
  GH_PAGE_URL = "http://git.io/brainz"
end
