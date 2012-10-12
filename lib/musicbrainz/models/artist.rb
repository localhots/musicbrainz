module MusicBrainz
  class Artist
    include BaseModel

    field :id, String
    field :type, String
    field :name, String
    field :country, String
    field :date_begin, Time
    field :date_end, Time
    field :urls, Hash

    attr_writer :release_groups

    def release_groups
      @release_groups ||= Client::load(:release_group, { artist: id }, {
        binding: MusicBrainz::Bindings::ArtistReleaseGroups,
        create_models: MusicBrainz::ReleaseGroup,
        sort: :first_release_date
      }) unless @id.nil?
    end

    class << self
      def find(id)
        Client.load(:artist, { id: id, inc: [:url_rels] }, {
          binding: MusicBrainz::Bindings::Artist,
          create_model: MusicBrainz::Artist
        })
      end

      def search(name)
        name = CGI.escape(name).gsub(/\!/, '\!')

        Client.load(:artist, { query: "artist:#{name}", limit: 10 }, {
          binding: MusicBrainz::Bindings::ArtistSearch
        })
      end

      def discography(mbid)
        artist = find(mbid)
        artist.release_groups.each { |rg| rg.releases.each { |r| r.tracks } }
        artist
      end

      def find_by_name(name)
        matches = search(name)
        matches.empty? ? nil : find(matches.first[:id])
      end
    end
  end
end
