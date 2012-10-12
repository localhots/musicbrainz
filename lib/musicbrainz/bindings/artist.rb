# encoding: UTF-8
module MusicBrainz
  module Bindings
    module Artist
      def parse(xml)
        xml = xml.xpath('./artist') unless xml.xpath('./artist').empty?
        {
          id: (xml.attribute('id').value rescue nil),
          type: (xml.attribute('type').value rescue nil),
          name: (xml.xpath('./name').text.gsub(/[`’]/, "'") rescue nil),
          country: (xml.xpath('./country').text rescue nil),
          date_begin: (xml.xpath('./life-span/begin').text rescue nil),
          date_end: (xml.xpath('./life-span/end').text rescue nil),
          urls: (Hash[xml.xpath('./relation-list[@target-type="url"]/relation').map{ |xml|
            [xml.attribute('type').value.downcase.split(" ").join("_").to_sym, xml.xpath('./target').text]
          }] rescue {})
        }
      end

      extend self
    end
  end
end
