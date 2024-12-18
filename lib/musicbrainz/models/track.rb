module MusicBrainz
  class Track < BaseModel
    field :id, String
    field :position, Integer
    field :recording_id, String
    field :title, String
    field :length, Integer

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
