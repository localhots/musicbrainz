# encoding: UTF-8
module MusicBrainz
  module Bindings
    module RecordingSearch
      def parse(xml)
        xml.xpath('./recording-list/recording').map do |xml|
          {
            id: (xml.attribute('id').value rescue nil),
            mbid: (xml.attribute('id').value rescue nil), # Old shit
            title: (xml.xpath('./title').text.gsub(/[`’]/, "'") rescue nil),
            artist: (xml.xpath('./artist-credit/name-credit/artist/name').text rescue nil),
            releases: (xml.xpath('./release-list/release/title').map{ |xml| xml.text } rescue []),
            score: (xml.attribute('score').value.to_i rescue nil)
          } rescue nil
        end.delete_if{ |item| item.nil? }
      end

      extend self
    end
  end
end
