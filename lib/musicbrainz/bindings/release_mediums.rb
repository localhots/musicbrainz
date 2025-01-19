module MusicBrainz
  module Bindings
    module ReleaseMediums
      def parse(xml)
        xml.xpath('./release/medium-list/medium').map do |xml|
          MusicBrainz::Bindings::Medium.parse(xml)
        end
      end

      extend self
    end
  end
end
