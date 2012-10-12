module MusicBrainz
  class Release
    include BaseModel

    field :id, String
    field :title, String
    field :status, String
    field :format, String
    field :date, Time
    field :country, String

    attr_writer :tracks

    def tracks
      @tracks ||= Client::load(:release, { id: id, inc: [:recordings, :media], limit: 100 }, {
        binding: MusicBrainz::Bindings::ReleaseTracks,
        create_models: MusicBrainz::Track,
        sort: :position
      }) unless @id.nil?
    end

    class << self
      def find(id)
        Client.load(:release, { id: id, inc: [:media] }, {
          binding: MusicBrainz::Bindings::Release,
          create_model: MusicBrainz::Release
        })
      end
    end
  end
end
