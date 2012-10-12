module MusicBrainz
  module Bindings
    module ArtistReleaseGroups
      def parse(xml)
        xml.xpath('./release-group-list/release-group').map do |xml|
          MusicBrainz::Bindings::ReleaseGroup.parse(xml)
        end
      end

      extend self
    end
  end
end
