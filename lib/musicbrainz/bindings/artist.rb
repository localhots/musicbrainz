module MusicBrainz
  module Bindings
    module Artist
      def parse(xml)
        xml = xml.xpath('./artist') 

        return {} if xml.empty?
        
        {
          id: (xml.attribute('id').value rescue nil),
          type: (xml.attribute('type').value rescue nil),
          name: (xml.xpath('./name').text.gsub(/[`’]/, "'") rescue nil),
          country: (xml.xpath('./country').text rescue nil),
          date_begin: (xml.xpath('./life-span/begin').text rescue nil),
          date_end: (xml.xpath('./life-span/end').text rescue nil)
        }.merge(Relations.parse(xml))
      end

      extend self
    end
  end
end
