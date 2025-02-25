module MusicBrainz
  class Recording < BaseModel
    field :id, String
    field :mbid, String
    field :title, String
    field :artist, String
		field :releases, String
		field :score, Integer
    field :isrcs, Array

    class << self
      def find(id)
				super({ id: id, inc: [:isrcs] })
      end

			def search(track_name, artist_name)
				super({recording: track_name, artist: artist_name})
			end
    end
  end
end
