module MusicBrainz
  module Bindings
    module Medium
      def parse(xml)
        {
          position: (xml.xpath('./position').text rescue nil),
          format: (xml.xpath('./format').text rescue nil),
        }
      end

      extend self
    end
  end
end
