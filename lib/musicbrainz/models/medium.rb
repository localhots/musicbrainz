module MusicBrainz
  class Medium < BaseModel
    field :position, Integer
    field :format, String
    field :tracks, Array

    def tracks=(tracks_data)
      @tracks = tracks_data.map { |track_data| Track.new(track_data) }
    end
  end
end
