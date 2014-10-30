module MusicBrainz
  module Bindings
    module ReleaseArtists
      def parse(xml)
        xml.xpath('./artist-list').map do |xml|
          MusicBrainz::Bindings::Artist.parse(xml)
        end
      end

      extend self
    end
  end
end
