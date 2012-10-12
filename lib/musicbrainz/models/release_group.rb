module MusicBrainz
  class ReleaseGroup
    include BaseModel

    field :id, String
    field :type, String
    field :title, String
    field :desc, String
    field :first_release_date, Time

    alias_method :disambiguation, :desc
    attr_writer :releases

    def releases
      @releases ||= Client::load(:release, { release_group: id, inc: [:media], limit: 100 }, {
        binding: MusicBrainz::Bindings::ReleaseGroupReleases,
        create_models: MusicBrainz::Release,
        sort: :date
      }) unless @id.nil?
    end

    class << self
      def find(id)
        Client.load(:release_group, { id: id }, {
          binding: MusicBrainz::Bindings::ReleaseGroup,
          create_model: MusicBrainz::ReleaseGroup
        })
      end
    end
  end
end
