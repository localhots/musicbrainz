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
        'MusicBrainz::Release', { release_group: id, inc: [:media, :release_groups, :recordings], limit: 100 }.merge(query), sort: :date
      )
    end

    class << self
      def search(artist, title, options = {})
        if artist.split('-').length != 5
          artist = CGI.escape(artist).gsub(/\!/, '\!')  
        end
        
        title = CGI.escape(title).gsub(/\!/, '\!')
        extra_query = options[:extra_query] ? options[:extra_query] : ''
        extra_query += " AND type:#{options[:type]}" if options[:type]
        
        params = {}
        params[:offset] = options[:offset] if options.has_key? :offset
        
        if artist.split('-').length == 5
          params[:query] = "arid:#{artist} AND releasegroup:\"#{title}*\" #{extra_query}"
          client.search('MusicBrainz::ReleaseGroup', params, create_models: false)
        else
          params[:query] = "artistname:\"#{artist}\" AND releasegroup:\"#{title}*\" #{extra_query}"
          client.search('MusicBrainz::ReleaseGroup', params, create_models: false)
        end
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
