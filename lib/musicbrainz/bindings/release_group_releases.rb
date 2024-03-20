module MusicBrainz
  module Bindings
    module ReleaseGroupReleases
      def parse(xml)
        xml.xpath('./release-list/release').map do |xml|
          MusicBrainz::Bindings::Release.parse(xml)
        end
      end

      extend self
    end
  end
end
