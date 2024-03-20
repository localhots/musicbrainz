module MusicBrainz
  class ReleaseGroup < BaseModel
    field :id, String
    field :type, String
    field :title, String
    field :desc, String
    field :first_release_date, Date
    field :urls, Hash

    alias_method :disambiguation, :desc

    def releases
      @releases ||= client.load(:release, { release_group: id, inc: [:media, :release_groups], limit: 100 }, {
        binding: :release_group_releases,
        create_models: :release,
        sort: :date
      }) unless @id.nil?
    end

    class << self
      def find(id)
        client.load(:release_group, { id: id, inc: [:url_rels] }, {
          binding: :release_group,
          create_model: :release_group
        })
      end
      
      def search(artist_name, title, type = nil)
				if type
					super({artist: artist_name, releasegroup: title, type: type})
				else
					super({artist: artist_name, releasegroup: title})
				end
      end
      
      def find_by_artist_and_title(artist_name, title, type = nil )
        matches = search(artist_name, title, type)
        matches.nil? || matches.empty? ? nil : find(matches.first[:id])
      end
    end
  end
end
