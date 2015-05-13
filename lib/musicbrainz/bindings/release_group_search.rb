# -*- encoding : utf-8 -*-
module MusicBrainz
  module Bindings
    module ReleaseGroupSearch
      def parse(xml)
        xml.xpath('./release-group-list/release-group').map do |xml|
          {
            id: (xml.attribute('id').value rescue nil),
            mbid: (xml.attribute('id').value rescue nil), # Old shit
            title: (xml.xpath('./title').text.gsub(/[`’]/, "'") rescue nil),
            type: (xml.attribute('type').value rescue nil),
            score: (xml.attribute('score').value.to_i rescue nil)
          } rescue nil
        end.delete_if{ |item| item.nil? }
      end

      extend self
    end
  end
end
