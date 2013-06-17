module MusicBrainz
  class Recording < BaseModel
    include Mapper::Resources::Recording
    
    include Concerns::ArtistName
    
    # user_tags user_ratings
    INCLUDES = %w(artists releases artist_credits tags ratings annotation url_rels artist-rels label_rels recording_rels release_rels release_group_rels url_rels work_rels)
    
    class << self
      def search(artist_name, title, options = {})
        artist_name = CGI.escape(artist_name).gsub(/\!/, '\!')
        title = CGI.escape(title).gsub(/\!/, '\!')
        query = ["artist:\"#{artist_name}\"", "recording:\"#{title}\""]
        query << "type: #{options[:type]}" if options[:type]

        client.search(to_s, query.join(' AND '), create_models: false)
      end
      
      def find_by_artist_and_title(artist_name, title, options = {})
        matches = search(artist_name, title, options)
        matches.empty? ? nil : find(matches.first[:id])
      end
    end
  end
end
