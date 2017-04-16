# -*- encoding : utf-8 -*-
module MusicBrainz
  class Track < BaseModel
    field :position, Integer
    field :recording_id, String
    field :title, String
    field :length, Integer
    field :disc, Integer

    class << self
      def find(id)
        client.load(:recording, { id: id }, {
          binding: :track,
          create_model: :track
        })
      end
    end
  end
end
