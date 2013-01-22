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
      
      def search(artist_name, title, options = {})
        artist_name = CGI.escape(artist_name).gsub(/\!/, '\!')
        title = CGI.escape(title).gsub(/\!/, '\!')
        query = ["artist:\"#{artist_name}\"", "releasegroup:\"#{title}\""]
        query << "type: #{options[:type]}" if options[:type]

        client.load(
          :release_group, { query: query.join(' AND '), limit: 10 }, 
          { binding: :release_group_search }
        )
      end
      
      def find_by_artist_and_title(artist_name, title, options = {})
        matches = search(artist_name, title, options)
        matches.empty? ? nil : find(matches.first[:id])
      end
    end
  end
end
