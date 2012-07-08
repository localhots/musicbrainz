# -*- encoding: utf-8 -*-

module MusicBrainz
  class Track < Base

    field :position, Integer
    field :recording_id, String
    field :title, String
    field :length, Integer

    class << self
      def find(mbid)
        load({
          :parser => :track_model,
          :create_model => MusicBrainz::Track
        }, {
          :resource => :recording,
          :id => mbid
        })
      end
    end
  end
end
