module MusicBrainz
  class Recording < BaseModel
    include Mapper::Resources::Recording
    
    include Concerns::ArtistName
    
    # user_tags user_ratings
    INCLUDES = %w(artists releases artist_credits tags ratings annotation url_rels artist-rels label_rels recording_rels release_rels release_group_rels url_rels work_rels)
    
    class << self
      def search(artist, title, options = {})
        if artist.split('-').length != 5
          artist = CGI.escape(artist).gsub(/\!/, '\!')  
        end
        
        title = CGI.escape(title).gsub(/\!/, '\!') unless title.nil?
        
        query = artist.split('-').length == 5 ? ["arid:\"#{artist}\""] : ["artist:\"#{artist}\""]
        query << "recording:\"#{title}\"" unless title.nil?
        query << "type: #{options[:type]}" if options[:type]

        params = { query: query.join(' AND ') }
        params[:limit] = options[:limit] if options.has_key? :limit
        params[:offset] = options[:offset] if options.has_key? :offset
        options = { create_models: false }.merge(options)
        
        client.search(to_s, params, create_models: options[:create_models])
      end
      
      def find_by_artist_and_title(artist_name, title, options = {})
        matches = search(artist_name, title, options)
        matches.empty? ? nil : find(matches.first[:id])
      end
    end
  end
end
