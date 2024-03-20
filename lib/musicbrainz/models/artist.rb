module MusicBrainz
  class Artist < BaseModel
    field :id, String
    field :type, String
    field :name, String
    field :country, String
    field :date_begin, Date
    field :date_end, Date
    field :urls, Hash

    def release_groups
      @release_groups ||= client.load(:release_group, { artist: id, inc: [:url_rels] }, {
        binding: :artist_release_groups,
        create_models: :release_group,
        sort: :first_release_date
      }) unless @id.nil?
    end

    class << self
      def find(id)
        client.load(:artist, { id: id, inc: [:url_rels] }, {
          binding: :artist,
          create_model: :artist
        })
      end

      def search(name)
				super({artist: name})
      end

      def discography(mbid)
        artist = find(mbid)
        artist.release_groups.each { |rg| rg.releases.each { |r| r.tracks } }
        artist
      end

      def find_by_name(name)
        matches = search(name)
        if matches and not matches.empty?
          find(matches.first[:id])
        end
      end
    end
  end
end
