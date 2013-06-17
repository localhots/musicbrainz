module MusicBrainz
  class ReleaseGroup < BaseModel
    include Mapper::Resources::ReleaseGroup
    
    xml_accessor :mbid, from: '@id' # deprecated
    
    alias_method :desc, :disambiguation
    
    # user_tags user_ratings
    INCLUDES = %w(artists releases artist_credits tags ratings discids media artist_credits annotation url_rels artist_rels label_rels recording_rels release_rels release_group_rels url_rels work_rels)

    def releases(query = {})
      return if @id.nil?
      
      return @releases if @releases || do_not_search
      
      @releases ||= client.search(
        'MusicBrainz::Release', { release_group: id, inc: [:media, :release_groups] }.merge(query), sort: :date
      )
    end

    class << self
      def search(artist_name, title, options = {})
        artist_name = CGI.escape(artist_name).gsub(/\!/, '\!')
        title = CGI.escape(title).gsub(/\!/, '\!')
        query = ["artist:\"#{artist_name}\"", "releasegroup:\"#{title}\""]
        query << "type: #{options[:type]}" if options[:type]
        
        client.search('MusicBrainz::ReleaseGroup', query.join(' AND '), create_models: false)
      end
      
      def find_by_artist_and_title(artist_name, title, options = {})
        matches = search(artist_name, title, options)
        matches.empty? ? nil : find(matches.first[:id])
      end
      
      def find_by_artist_id(artist_id)
        Artist.new(id: artist_id).release_groups
      end
    end
  end
end
