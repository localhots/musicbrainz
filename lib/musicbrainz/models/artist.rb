module MusicBrainz
  class Artist < BaseModel
    include Mapper::Resources::Artist
    
    xml_accessor :mbid, from: '@id' # deprecated
    
    # user_tags user_ratings
    INCLUDES = %w(release_groups releases works recordings aliases tags ratings discids media puids isrcs artist_credits various_artists annotation url_rels artist_rels label_rels recording_rels release_rels release_group_rels work_rels)
    
    def release_groups(options = {})
      return @release_groups if @release_groups || @id.nil? || do_not_search
      
      params = { artist: id, inc: [:url_rels, :artist_credits], limit: 100 }
      params[:offset] = options[:offset] if options.has_key? :offset
      
      client.search(
        'MusicBrainz::ReleaseGroup', params, sort: :first_release_date
      )
    end
    
    class << self
      def search(name)
        name = CGI.escape(name).gsub(/\!/, '\!')
        client.search(to_s, "artist:\"#{name}\"", create_models: false)
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
