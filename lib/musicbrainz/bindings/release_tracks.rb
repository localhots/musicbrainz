module MusicBrainz
  module Bindings
    module ReleaseTracks
      def parse(xml)
        xml.xpath('./release/medium-list/medium').map do |xml|
          disc_number = xml.xpath('./position').text rescue nil
          xml.xpath('./track-list/track').map do |xml|
            MusicBrainz::Bindings::Track.parse(xml).merge(disc: disc_number)
          end
        end.flatten
      end

      extend self
    end
  end
end
