module MusicBrainz
  module Bindings
    module ReleaseArtists
      def parse(xml)
        xml.xpath('./release/artist-credit/name-credit').map do |xml|
          MusicBrainz::Bindings::Artist.parse(xml)
        end
      end

      extend self
    end
  end
end
