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
      
      def search(artist_name, title, options = {})
        artist_name = CGI.escape(artist_name).gsub(/\!/, '\!')
        title = CGI.escape(title).gsub(/\!/, '\!')
        query = ["artist:\"#{artist_name}\"", "releasegroup:\"#{title}\""]
        query << "type: #{options[:type]}" if options[:type]

        Client.load(
          :release_group, { query: query.join(' AND '), limit: 10 }, 
          { binding: MusicBrainz::Bindings::ReleaseGroupSearch }
        )
      end
      
      def find_by_artist_and_title(artist_name, title, options = {})
        matches = search(artist_name, title, options)
        matches.empty? ? nil : find(matches.first[:id])
      end
    end
  end
end
