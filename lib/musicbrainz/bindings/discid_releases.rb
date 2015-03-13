module MusicBrainz
  module Bindings
    module DiscidReleases
      def parse(xml)
        xml.xpath('./disc/release-list/release').map do |xml|
          MusicBrainz::Bindings::Release.parse(xml)
        end
      end

      extend self
    end
  end
end
