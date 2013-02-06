module MusicBrainz
  module Bindings
    module ReleaseGroup
      def parse(xml)
        xml = xml.xpath('./release-group') unless xml.xpath('./release-group').empty?
        {
          id: (xml.attribute('id').value rescue nil),
          type: (xml.attribute('type').value rescue nil),
          title: (xml.xpath('./title').text rescue nil),
          desc: (xml.xpath('./disambiguation').text rescue nil),
          first_release_date: (xml.xpath('./first-release-date').text rescue nil),
          urls: (Hash[xml.xpath('./relation-list[@target-type="url"]/relation').map{ |xml|
            [xml.attribute('type').value.downcase.split(" ").join("_").to_sym, xml.xpath('./target').text]
          }] rescue {})
        }
      end

      extend self
    end
  end
end
