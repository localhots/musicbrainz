module MusicBrainz
  module Bindings
    module Medium
      def parse(xml)
        {
          position: (xml.xpath('./position').text rescue nil),
          format: (xml.xpath('./format').text rescue nil),
          tracks: xml.xpath('./track-list/track').map do |track_xml|
            MusicBrainz::Bindings::Track.parse(track_xml)
          end
        }
      end

      extend self
    end
  end
end
