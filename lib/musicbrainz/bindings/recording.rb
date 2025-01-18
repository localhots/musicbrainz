module MusicBrainz
  module Bindings
    module Recording
      def parse(xml)
        xml = xml.xpath('./recording') unless xml.xpath('./recording').empty?
        {
          id: (xml.attribute('id').value rescue nil),
          mbid: (xml.attribute('id').value rescue nil), # Old shit
          title: (xml.xpath('./title').text.gsub(/[`’]/, "'") rescue nil),
          artist: (xml.xpath('./artist-credit/name-credit/artist/name').text rescue nil),
          releases: (xml.xpath('./release-list/release/title').map{ |xml| xml.text } rescue []),
          score: (xml.attribute('score').value.to_i rescue nil),
          isrcs: (xml.xpath('./isrc-list/isrc/@id').map(&:text) rescue [])
        }
      end

      extend self
    end
  end
end
