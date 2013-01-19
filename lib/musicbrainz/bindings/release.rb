module MusicBrainz
  module Bindings
    module Release
      def parse(xml)
        xml = xml.xpath('./release') unless xml.xpath('./release').empty?
        
        hash = {
          id: (xml.attribute('id').value rescue nil),
          title: (xml.xpath('./title').text rescue nil),
          status: (xml.xpath('./status').text rescue nil),
          country: (xml.xpath('./country').text rescue nil),
          date: (xml.xpath('./date').text rescue nil)
        }
        
        formats = (xml.xpath('./medium-list/medium/format') rescue []).map(&:text)
        
        hash[:format] = formats.uniq.map do |format|
          format_count = formats.select{|f| f == format}.length
          format_count == 1 ? format : "#{format_count}x#{format}"
        end.join(' + ')
        
        hash
      end

      extend self
    end
  end
end
