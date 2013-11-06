module MusicBrainz
  class Recording < BaseModel
    field :id, Integer
    field :mbid, Integer
    field :title, String
    field :artist, String
		field :releases, String
		field :score, Integer

    class << self
      def find(id)
				super({ id: id })
      end

			def search(track_name, artist_name)
				super({recording: track_name, artist: artist_name})
			end
    end
  end
end
