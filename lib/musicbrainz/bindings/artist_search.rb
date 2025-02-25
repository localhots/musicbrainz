module MusicBrainz
  module Bindings
    module ArtistSearch
      def parse(xml)
        xml.xpath('./artist-list/artist').map do |xml|
          {
            id: (xml.attribute('id').value rescue nil),
            mbid: (xml.attribute('id').value rescue nil), # Old shit
            name: (xml.xpath('./name').text.gsub(/[`’]/, "'") rescue nil),
            sort_name: (xml.xpath('./sort-name').gsub(/[`’]/, "'") rescue nil),
            area: (xml.xpath('./area').children.first.children.text rescue nil),
            type: (xml.attribute('type').value rescue nil),
            score: (xml.attribute('score').value.to_i rescue nil),
            desc: (xml.xpath('./disambiguation').children.first.text rescue nil),
            aliases: (xml.xpath('./alias-list/alias').map{ |xml| xml.text } rescue [])
          } rescue nil
        end.delete_if{ |item| item.nil? }
      end

      extend self
    end
  end
end
