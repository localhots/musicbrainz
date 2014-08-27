# encoding: UTF-8
module MusicBrainz
  module Bindings
    module ReleaseSearch
      def parse(xml)
        xml.xpath('./release-list/release').map do |xml|
          {
            id: (xml.attribute('id').value rescue nil),
            mbid: (xml.attribute('id').value rescue nil), # Old shit
            title: (xml.xpath('./title').text.gsub(/[`’]/, "'") rescue nil),
            type: (xml.attribute('type').value rescue nil),
            score: (xml.attribute('score').value.to_i rescue nil),
            asin: (xml.xpath('./asin').text rescue nil),
            barcode: (xml.xpath('./barcode').text rescue nil),
            country: (xml.xpath('./country').text rescue nil),
            date: (xml.xpath('./date').text rescue nil),
          } rescue nil
        end.delete_if{ |item| item.nil? }
      end

      extend self
    end
  end
end
