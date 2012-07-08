# -*- encoding: utf-8 -*-

module MusicBrainz
  module Parsers
    class ReleaseGroup < Base
      class << self
        def model(xml)
          {
            :id => safe_get_attr(xml, nil, "id"),
            :type => safe_get_attr(xml, nil, "type"),
            :title => safe_get_value(xml, "title"),
            :disambiguation => safe_get_value(xml, "disambiguation"),
            :first_release_date => safe_get_value(xml, "first-release-date")
          }
        end
      end
    end
  end
end
