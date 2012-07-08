# -*- encoding: utf-8 -*-

module MusicBrainz
  module Parsers
    class Release < Base
      class << self
        def model(xml)
          {
            :id => safe_get_attr(xml, nil, "id") || safe_get_attr(xml, "release", "id"),
            :title => safe_get_value(xml, "title"),
            :status => safe_get_value(xml, "status"),
            :country => safe_get_value(xml, "country"),
            :format => safe_get_value(xml, "medium-list > medium > format"),
            :date => safe_get_value(xml, "date")
          }
        end

        def tracks(xml)
          tracks = []
          xml.css("medium-list > medium > track-list > track").each do |r|
            tracks << MusicBrainz::Parsers::Track.model(r)
          end
          tracks
        end
      end
    end
  end
end
