module MusicBrainz
  module Bindings
    module ReleaseTracks
      def parse(xml)
        xml.xpath('./release/medium-list/medium/track-list/track').map do |xml|
          MusicBrainz::Bindings::Track.parse(xml)
        end
      end

      extend self
    end
  end
end
