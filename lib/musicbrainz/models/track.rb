module MusicBrainz
  class Track < BaseModel
    field :position, Integer
    field :disc, Integer
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

			def search(artist_name, track_name)
				super({artist: artist_name, recording: track_name})
			end
    end
  end
end
