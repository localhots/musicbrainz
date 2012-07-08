# -*- encoding: utf-8 -*-

module MusicBrainz
  module Parsers
    class Track < Base
      class << self
        def model(xml)
          {
            :position => safe_get_value(xml, "position"),
            :recording_id => safe_get_attr(xml, "recording", "id"),
            :title => safe_get_value(xml, "recording > title"),
            :length => safe_get_value(xml, "length") || safe_get_value(xml, "recording > length")
          }
        end
      end
    end
  end
end
