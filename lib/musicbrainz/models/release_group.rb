module MusicBrainz
  class ReleaseGroup < BaseModel
    field :id, String
    field :type, String
    field :title, String
    field :desc, String
    field :first_release_date, Date

    alias_method :disambiguation, :desc

    def releases
      @releases ||= client.load(:release, { release_group: id, inc: [:media], limit: 100 }, {
        binding: :release_group_releases,
        create_models: :release,
        sort: :date
      }) unless @id.nil?
    end

    class << self
      def find(id)
        client.load(:release_group, { id: id }, {
          binding: :release_group,
          create_model: :release_group
        })
      end
    end
  end
end
