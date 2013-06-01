module MusicBrainz
  class Track < BaseModel
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

			def search(artist_name, track_name)
				# this model really should be named "recording" I'd rename, but I don't want to break anything
				super({recording: track_name, artist: artist_name}, "recording")
			end
    end
  end
end
