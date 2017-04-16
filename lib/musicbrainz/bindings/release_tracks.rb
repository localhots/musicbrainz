# -*- encoding : utf-8 -*-
module MusicBrainz
  module Bindings
    module ReleaseTracks
      def parse(xml)
        array = []
        xml.xpath('./release/medium-list/medium').map do |xml|
          xml.xpath('./track-list/track').map do |doc|
            track = MusicBrainz::Bindings::Track.parse(doc)
            track[:disc] = xml.xpath('./position').text
            array << track
          end
        end
        array
      end

      extend self
    end
  end
end
