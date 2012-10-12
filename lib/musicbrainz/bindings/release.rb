module MusicBrainz
  module Bindings
    module Release
      def parse(xml)
        xml = xml.xpath('./release') unless xml.xpath('./release').empty?
        {
          id: (xml.attribute('id').value rescue nil),
          title: (xml.xpath('./title').text rescue nil),
          status: (xml.xpath('./status').text rescue nil),
          country: (xml.xpath('./country').text rescue nil),
          format: (xml.xpath('./medium-list/medium/format').text rescue nil),
          date: (xml.xpath('./date').text rescue nil)
        }
      end

      extend self
    end
  end
end
