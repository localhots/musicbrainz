module MusicBrainz
  class Release < BaseModel
    field :id, String
    field :type, String
    field :title, String
    field :status, String
    field :format, String
    field :date, Date
    field :country, String
    field :asin, String
    field :barcode, String
    field :quality, String

    def tracks
      @tracks ||= client.load(:release, { id: id, inc: [:recordings, :media], limit: 100 }, {
        binding: :release_tracks,
        create_models: :track,
        sort: :position
      }) unless @id.nil?
    end

    class << self
      def find(id)
        client.load(:release, { id: id, inc: [:media, :release_groups] }, {
          binding: :release,
          create_model: :release
        })
      end

      def find_by_discid(id)
        client.load(:discid, { id: id }, {
          binding: :discid_releases,
          create_models: :release
        })
      end
    end
  end
end
