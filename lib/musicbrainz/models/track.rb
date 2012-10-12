module MusicBrainz
  class Track
    include BaseModel

    field :position, Integer
    field :recording_id, String
    field :title, String
    field :length, Integer

    class << self
      def find(id)
        Client.load(:recording, { id: id }, {
          binding: MusicBrainz::Bindings::Track,
          create_model: MusicBrainz::Track
        })
      end
    end
  end
end
