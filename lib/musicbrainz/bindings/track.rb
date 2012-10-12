module MusicBrainz
  module Bindings
    module Track
      def parse(xml)
        {
          position: (xml.xpath('./position').text rescue nil),
          recording_id: (xml.xpath('./recording').attribute('id').value rescue nil),
          title: (xml.xpath('./recording/title').text rescue nil),
          length: (xml.xpath('./recording/length').text rescue nil)
        }
      end

      extend self
    end
  end
end
